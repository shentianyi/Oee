require 'csv'
module FileHandler
  module Csv
    class DowntimeRecordHandler<Base
      IMPORT_HEADERS=['FORS_werk', 'FORS_faufnr', 'FORS_faufpo', 'FORS_lnr', 'FORS_einres', 'PK_Sch', 'PK_Datum', 'PK_SchStd', 'PK_SchT', 'PD_ProdNr', 'PD_TEB',
                      'PD_Stueck', 'PD_Auss_Ruest', 'PD_Auss_Prod', 'PD_Bemerk', 'PD_User', 'PD_ErfDat', 'PD_von', 'PD_bis', 'PD_Stoer', 'PD_Std', 'PD_Laenge',
                      'PD_Rf']
      INVALID_CSV_HEADERS=IMPORT_HEADERS + ['Error MSG']

      def self.recombine keys, values
        values.each_with_index do |rv, index|
          if rv.present? && rv.is_date?
            return keys.zip(values[index, values.count]).to_h
          end
        end
        keys.zip(values).to_h
      end

      def self.import(file)
        msg = Message.new
        begin
          # validate_msg = validate_import(file)
          if true #validate_msg.result
            DowntimeRecord.transaction do

              #machine hash container
              machine_container = {}
              #preview order params
              pre_order={}

              #traversal file
              CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
                row.strip

                #parse params
                params = {}
                IMPORT_HEADERS.each do |header|
                  if header=='PD_ErfDat'
                    if row[header].blank? || !row[header].is_date?
                      params = params.merge(recombine(IMPORT_HEADERS - params.keys, row.fields[params.keys.count, row.fields.count]))
                      break
                    end
                  end
                  params[header] = row[header]
                end

                params['FORS_einres']=Machine.find_by_nr(params['FORS_einres']).id
                params['PD_ProdNr']=Craft.find_by_nr(params['PD_ProdNr']).id
                params['PD_Stoer']=DowntimeCode.find_by_nr(params['PD_Stoer']).id

                #supplement params
                if params['PD_Bemerk']==pre_order['PD_Bemerk']
                  params['PD_ProdNr']=pre_order['PD_ProdNr']
                  params['PD_Stueck']=pre_order['PD_Stueck']
                  params['PD_Laenge']=pre_order['PD_Laenge']
                else
                  pre_order=params
                end

                #push data into container
                if machine_container[row['FORS_einres']].blank?
                  machine_container[row['FORS_einres']] = {}
                end
                machine_container[row['FORS_einres']][(params['PD_ErfDat'] + ' ' + params['PD_von']).to_time] = params


                puts params
                puts '--------------------------------------------------------------------------------------'
              end

              p machine_container
              # p (machine_container['08708-15'].keys + ['2016-08-20 10:19:00'.to_time, '2016-08-20 10:29:00'.to_time, '2016-08-20 10:09:00'.to_time]).sort
              # p machine_container['08708-15']['2016-08-20 10:19:00'.to_time]
              # p machine_container['08708-15']['2016-08-20 11:19:00'.to_time]

              #traversal container
              pre_order={}
              pre_record={}
              pre_order_downtime=0
              curr_shift_first_record = nil
              machine_container.keys.each do |machine_nr|
                machine_container[machine_nr].keys.sort.each do |time|
                  p machine_container[machine_nr][time]
                  #set default current shift first record if curr_shift_first_record is nil
                  curr_shift_first_record=machine_container[machine_nr][time] if curr_shift_first_record.blank?

                  #换班了，为上个班次添加可能的 J1记录
                  if (machine_container[machine_nr][time]['PK_SchT'] != pre_record['PK_SchT']) && pre_record.present? && pre_record.present?
                    #set current shift first record
                    curr_shift_first_record=machine_container[machine_nr][time]
                    #用秒计量前一个订单的工时
                    machine_type = Machine.find_by_id(pre_record['FORS_einres']).machine_type
                    craft = Craft.find_by_id(pre_record['PD_ProdNr'])
                    p order_work_time = WorkTime.search_work_time(machine_type, craft, pre_record['PD_Laenge'])*pre_record['PD_Stueck'].to_f*60

                    p msg = self.check_shift((curr_shift_first_record['PD_ErfDat'] + ' ' + curr_shift_first_record['PD_von']).to_time,
                                          (pre_record['PD_ErfDat'] + ' ' + pre_record['PD_von']).to_time)
                  end

                  #换订单了
                  if machine_container[machine_nr][time]['PD_Bemerk'] != pre_order['PD_Bemerk']
                    pre_order=machine_container[machine_nr][time]
                    pre_order_downtime = 0
                  end

                  pre_order_downtime += machine_container[machine_nr][time]['PD_Std'].to_f*3600

                  pre_record=machine_container[machine_nr][time]
                end
              end

            end
            msg.result = true
            msg.content = '停机记录 上传成功'
          else
            msg.result = false
            msg.content = validate_msg.content
          end
        rescue => e
          puts e.backtrace
          msg.content = e.message
        end
        return msg
      end

      def self.validate_import(file)
        tmp_file=full_tmp_path(file.file_name)
        msg=Message.new(result: true)
        CSV.open(tmp_file, 'wb', write_headers: true,
                 headers: INVALID_CSV_HEADERS, col_sep: file.col_sep, encoding: file.encoding) do |csv|
          CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
            mmsg = validate_row(row)
            if mmsg.result
              csv<<row.fields
            else
              if msg.result
                msg.result=false
                msg.content = "请下载错误文件<a href='/files/#{Base64.urlsafe_encode64(tmp_file)}'>#{::File.basename(tmp_file)}</a>"
              end
              csv<<(row.fields<<mmsg.content)
            end
          end
        end
        return msg
      end

      def self.validate_row(row)
        msg=Message.new(contents: [])

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        return msg
      end

      def self.check_shift t1, t2
        msg=Message.new()

        first_shift = WorkShift.find_by_nr('FIRST')
        last_shift = WorkShift.find_by_nr('LAST')

        first_shift_start_time = (t1.to_s.to_date.to_s + ' ' + first_shift.start_time.strftime('%H:%M:%S')).to_time
        last_shift_start_time = (t1.to_s.to_date.to_s + ' ' + last_shift.start_time.strftime('%H:%M:%S')).to_time

        if t1 < first_shift_start_time
          t1_shift = first_shift_start_time-60
        elsif t1 >= last_shift_start_time
          t1_shift = last_shift_start_time + (last_shift.end_time-last_shift.start_time)
        else
          t1_shift = last_shift_start_time-60
        end

        if t2 < first_shift_start_time
          t2_shift = first_shift_start_time-60
        elsif t2 >= last_shift_start_time
          t2_shift = last_shift_start_time + (last_shift.end_time-last_shift.start_time)
        else
          t2_shift = last_shift_start_time-60
        end

        if (msg.result = (t1_shift==t2_shift))
          msg.object = {shift_over_time: t2_shift}
        end

        msg
      end

    end
  end
end

class String
  def is_date?
    true if Date.parse(self) && Time.parse(self) rescue false
  end
end

class CSV
  class Row
    def strip
      self.each do |value|
        value[1].strip! if value[1]
      end
    end
  end
end