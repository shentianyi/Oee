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
        # begin
        count = 0
        count_natual = 0
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
              # p row
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

              #supplement params
              if params['PD_Bemerk']==pre_order['PD_Bemerk']
                params['PD_ProdNr']=pre_order['PD_ProdNr'] if (pre_order['PD_ProdNr'].present? && params['PD_ProdNr'].blank?)
                pre_order['PD_ProdNr']=params['PD_ProdNr'] if (pre_order['PD_ProdNr'].blank? && params['PD_ProdNr'].present?)

                params['PD_Stueck']=params['PD_Stueck'].to_i|pre_order['PD_Stueck'].to_i #if (pre_order['PD_Stueck'].present? && params['PD_Stueck'].blank?)
                params['PD_Laenge']=params['PD_Laenge'].to_i|pre_order['PD_Laenge'].to_i #if (pre_order['PD_Laenge'].present? && params['PD_Laenge'].blank?)
              else
                # #源数据非正常顺序排列
                # if machine_container[row['FORS_einres']].present? && (params['PD_ProdNr'].blank? || params['PD_Stueck'].blank? || params['PD_Laenge'].blank?)
                #   p machine_container[row['FORS_einres']]
                #   if (already_pre_order = machine_container[row['FORS_einres']].values.select{|h| h['PD_Bemerk'].to_s==params['PD_Bemerk'].to_s}.first).present?
                #     params['PD_ProdNr']=Craft.find_by_id(already_pre_order['PD_ProdNr']).id if (already_pre_order['PD_ProdNr'].present? && params['PD_ProdNr'].blank?)
                #     params['PD_Stueck']=already_pre_order['PD_Stueck'] if (already_pre_order['PD_Stueck'].present? && params['PD_Stueck'].blank?)
                #     params['PD_Laenge']=already_pre_order['PD_Laenge'] if (already_pre_order['PD_Laenge'].present? && params['PD_Laenge'].blank?)
                #   end
                # end
                pre_order=params.clone
              end

              if params['FORS_einres'].present? && machine=Machine.find_by_nr(params['FORS_einres'])
                params['FORS_einres']=machine.id
              else
                if params['PD_Stoer']=='J1'
                  params['FORS_einres']=Machine.find_by_nr('Other').id
                else
                  raise "机器号：#{params['FORS_einres']}未找到或不存在"
                end
              end
              if params['PD_ProdNr'].present? && craft=Craft.find_by_nr(params['PD_ProdNr'])
                params['PD_ProdNr']=craft.id
              else
                if (params['PD_Stoer']=='J1' || params['PD_Stueck'].to_i==0)
                  params['PD_ProdNr']=Craft.find_by_nr('Other').id
                else
                  raise "工艺号：#{params['PD_ProdNr']}未找到或不存在"
                end
              end
              if params['PD_Stoer'].present? && d_code=DowntimeCode.find_by_nr(params['PD_Stoer'])
                params['PD_Stoer']=d_code.id
              else
                raise "停机代码：#{params['PD_Stoer']}未找到或不存在"
              end

              #
              params['PD_von'] = (params['PD_ErfDat'] + ' ' + params['PD_von']).to_time
              params['PD_bis'] = (params['PD_ErfDat'] + ' ' + params['PD_bis']).to_time

              #push data into container
              if machine_container[row['FORS_einres']].blank?
                machine_container[row['FORS_einres']] = {}
                machine_container[row['FORS_einres']][params['PD_von']] = params
              else
                # 解决 同一机台中 会出现相同开始停机时间的记录
                if machine_container[row['FORS_einres']][params['PD_von']]
                  p '-----------------------------------'.red
                  59.times do |i|
                    if machine_container[row['FORS_einres']][params['PD_von']+i+1].blank?
                      machine_container[row['FORS_einres']][params['PD_von']+i+1] = params
                      break
                    end
                  end
                else
                  machine_container[row['FORS_einres']][params['PD_von']] = params
                end
              end

              puts params
              puts '--------------------------------------------------------------------------------------'
            end

            # p machine_container
            # p (machine_container['08708-15'].keys + ['2016-08-20 10:19:00'.to_time, '2016-08-20 10:29:00'.to_time, '2016-08-20 10:09:00'.to_time]).sort
            # p machine_container['08708-15']['2016-08-20 10:19:00'.to_time]
            # p machine_container['08708-15']['2016-08-20 11:19:00'.to_time]

            #traversal container
            puts '---------------------------------------分割线-----------------------------------------------'.red
            # kc=0
            # kp = 0
            # machine_container.keys.each do |machine_nr|
            #   puts machine_nr
            #   kc += machine_container[machine_nr].keys.count
            #   puts machine_container[machine_nr].keys.count
            #   kp += machine_container[machine_nr].keys.uniq.count
            #   puts machine_container[machine_nr].keys.uniq.count
            # end
            # puts kc
            # puts kp
            # raise 'gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg'

            machine_container.keys.each do |machine_nr|
              pre_order={}
              pre_record={}
              pre_order_downtime=0
              curr_shift_first_record = nil

              puts machine_container[machine_nr].keys.sort
              puts '---------------------------------------------------------------------------------------------------------------------'.green
              machine_container[machine_nr].keys.sort.each do |time|
                # p machine_container[machine_nr][time]

                #set default current shift first record if curr_shift_first_record is nil
                curr_shift_first_record=machine_container[machine_nr][time].clone if curr_shift_first_record.blank?

                #换班了，为上个班次添加可能的 J1记录
                if pre_record.present? && pre_order.present? &&
                    ((machine_container[machine_nr][time]['PK_SchT'] != pre_record['PK_SchT']) ||
                        !(self.check_shift(machine_container[machine_nr][time]['PD_von'], pre_record['PD_von']).result))

                  #set current shift first record
                  curr_shift_first_record=machine_container[machine_nr][time].clone
                  #用秒计量前一个订单的工时
                  machine_type = Machine.find_by_id(pre_record['FORS_einres']).machine_type
                  craft = Craft.find_by_id(pre_record['PD_ProdNr'])
                  order_work_time = WorkTime.search_work_time(machine_type, craft, pre_record['PD_Laenge'])*pre_record['PD_Stueck'].to_f

                  p msg = self.check_shift(pre_record['PD_von'], curr_shift_first_record['PD_von'])
                  p check_pre_record = self.check_shift(pre_record['PD_von'], pre_record['PD_bis'])

                  if !msg.result && check_pre_record.result
                    puts 'Insert Into Web System Calc Record .....'.red

                    insert_params = pre_record.clone
                    insert_params['PD_Stoer'] = DowntimeCode.find_by_nr('J1').id
                    insert_params['is_naturl'] = true

                    if order_work_time ==0
                      insert_params['PD_von'] = pre_record['PD_bis']
                      insert_params['PD_bis'] = msg.object[:shift_over_time]
                      insert_params['PD_Std'] = (insert_params['PD_bis'] - insert_params['PD_von'])/3600.0
                      p insert_params
                      puts "-------------------------------create  order_work_time=0--------------------------------".red
                      DowntimeRecord.create(parse_params insert_params)
                      count += 1
                    else
                      insert_params['PD_bis'] = msg.object[:shift_over_time]
                      nomal_finished_time = (pre_order['PD_bis'] + order_work_time + pre_order_downtime)
                      if nomal_finished_time < msg.object[:shift_over_time]
                        if nomal_finished_time < pre_record['PD_bis']
                          insert_params['PD_von'] = pre_record['PD_bis']
                        else
                          insert_params['PD_von'] = nomal_finished_time
                        end
                        insert_params['PD_Std'] = (insert_params['PD_bis'] - insert_params['PD_von'])/3600.0
                        p insert_params
                        puts "--------------------------------create-------------------------------".red
                        DowntimeRecord.create(parse_params insert_params)
                        count += 1
                      else
                        p nomal_finished_time
                        p msg.object[:shift_over_time]
                        puts '工作到班次结束，没有停机'.red
                      end
                    end
                  end
                end

                #create downtime record
                DowntimeRecord.create(parse_params machine_container[machine_nr][time])
                count_natual +=1

                #换订单了
                if machine_container[machine_nr][time]['PD_Bemerk'] != pre_order['PD_Bemerk']
                  pre_order=machine_container[machine_nr][time].clone
                  pre_order_downtime = 0
                end

                pre_order_downtime += machine_container[machine_nr][time]['PD_Std'].to_f*3600

                pre_record=machine_container[machine_nr][time].clone
              end

              # puts 'pre_order-------pre_record------pre_order_downtime-------curr_shift_first_record---------'
              # p pre_order
              # p pre_record
              # p pre_order_downtime
              # p curr_shift_first_record

              #insert record after last one per machine
              msg = self.check_shift(curr_shift_first_record['PD_von'], pre_record['PD_bis'])
              insert_params = {}
              if msg.result
                puts 'Insert Into Web System Calc Record .....'.yellow

                #用秒计量每个机器最后一个订单的工时
                machine_type = Machine.find_by_id(pre_record['FORS_einres']).machine_type
                craft = Craft.find_by_id(pre_record['PD_ProdNr'])
                order_work_time = WorkTime.search_work_time(machine_type, craft, pre_record['PD_Laenge'])*pre_record['PD_Stueck'].to_f

                insert_params = pre_record.clone
                insert_params['PD_Stoer'] = DowntimeCode.find_by_nr('J1').id
                insert_params['is_naturl'] = true

                if order_work_time ==0
                  insert_params['PD_von'] = pre_record['PD_bis']
                  insert_params['PD_bis'] = msg.object[:shift_over_time]
                  insert_params['PD_Std'] = (insert_params['PD_bis'] - insert_params['PD_von'])/3600.0
                  p insert_params
                  puts "-------------------------------create  1111--------------------------------".red
                  DowntimeRecord.create(parse_params insert_params)
                  count += 1
                else
                  insert_params['PD_bis'] = msg.object[:shift_over_time]
                  nomal_finished_time = (pre_order['PD_bis'] + order_work_time + pre_order_downtime)
                  if nomal_finished_time < msg.object[:shift_over_time]
                    if nomal_finished_time < pre_record['PD_bis']
                      insert_params['PD_von'] = pre_record['PD_bis']
                    else
                      insert_params['PD_von'] = nomal_finished_time
                    end
                    insert_params['PD_Std'] = (insert_params['PD_bis'] - insert_params['PD_von'])/3600.0
                    p insert_params
                    puts "--------------------------------create-------------------------------".red
                    DowntimeRecord.create(parse_params insert_params)
                    count += 1
                  else
                    p nomal_finished_time
                    p msg.object[:shift_over_time]
                    puts '工作到班次结束，没有停机'.red
                  end
                end
              end
            end

          end
          msg.result = true
          puts "------------------#{count_natual}---------------------------count #{count}-----------------------------------------".red
          msg.content = '停机记录  上传成功'
        else
          msg.result = false
          msg.content = validate_msg.content
        end
        # rescue => e
        #   puts e.backtrace
        #   msg.content = e.message
        # end
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
        first_shift_end_time = (t1.to_s.to_date.to_s + ' ' + first_shift.end_time.strftime('%H:%M:%S')).to_time
        last_shift_start_time = (t1.to_s.to_date.to_s + ' ' + last_shift.start_time.strftime('%H:%M:%S')).to_time
        last_shift_end_time = (t1.to_s.to_date.to_s + ' ' + last_shift.end_time.strftime('%H:%M:%S')).to_time

        if (t1 < first_shift_start_time && t1 >= (first_shift_start_time-(first_shift.end_time - first_shift.start_time)))
          t1_shift = first_shift_start_time-60
        elsif (t1 >= last_shift_start_time && t1 <= (last_shift_start_time + (last_shift.end_time-last_shift.start_time)))
          t1_shift = last_shift_start_time + (last_shift.end_time-last_shift.start_time)
        elsif (t1 >= first_shift_start_time && t1 < first_shift_end_time)
          t1_shift = last_shift_start_time-60
        else
          t1_shift = '1970-01-01 00:00:00'.to_time
        end

        if (t2 < first_shift_start_time && t2 >= (first_shift_start_time-(first_shift.end_time - first_shift.start_time)))
          t2_shift = first_shift_start_time-60
        elsif (t2 >= last_shift_start_time && t2 <= (last_shift_start_time + (last_shift.end_time-last_shift.start_time)))
          t2_shift = last_shift_start_time + (last_shift.end_time-last_shift.start_time)
        elsif (t2 >= first_shift_start_time && t2 < first_shift_end_time)
          t2_shift = last_shift_start_time-60
        else
          t2_shift = '1970-01-02 00:00:00'.to_time
        end

        if (msg.result = (t1_shift==t2_shift))
          msg.object = {shift_over_time: t2_shift.localtime}
        else
          msg.object = {shift_over_time: t1_shift.localtime}
        end

        msg
      end

      def self.parse_params params
        data={}

        data[:fors_werk] = params['FORS_werk']
        data[:fors_faufnr] = params['FORS_faufnr']
        data[:fors_faufpo] = params['FORS_faufpo']
        data[:fors_lnr] = params['FORS_lnr']
        data[:machine_id] = params['FORS_einres']
        data[:pk_sch] = params['PK_Sch']
        data[:pk_datum] = params['PK_Datum'].to_time

        data[:pk_sch_std] = params['PK_SchStd']
        data[:pk_sch_t] = params['PK_SchT']
        data[:craft_id] = params['PD_ProdNr']
        data[:pd_teb] = params['PD_TEB']
        data[:pd_stueck] = params['PD_Stueck']
        data[:pd_auss_ruest] = params['PD_Auss_Ruest']
        data[:pd_auss_prod] = params['PD_Auss_Prod']

        data[:pd_bemerk] = params['PD_Bemerk']
        data[:pd_user] = params['PD_User']
        data[:pd_erf_dat] = params['PD_ErfDat'].to_time
        data[:pd_von] = params['PD_von']

        data[:pd_bis] = params['PD_bis']
        data[:downtime_code_id] = params['PD_Stoer']
        data[:pd_std] = params['PD_Std'].to_s.gsub(/,/, '.').to_f
        data[:pd_laenge] = params['PD_Laenge']

        data[:pd_rf] = params['PD_Rf']
        data[:is_naturl] = params['is_naturl'] if params['is_naturl'].present?

        data
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