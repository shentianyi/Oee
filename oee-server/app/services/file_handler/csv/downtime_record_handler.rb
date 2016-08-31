require 'csv'
module FileHandler
  module Csv
    class DowntimeRecordHandler<Base
      IMPORT_HEADERS=['FORS_werk', 'FORS_faufnr', 'FORS_faufpo', 'FORS_lnr', 'FORS_einres', 'PK_Sch', 'PK_Datum', 'PK_SchStd', 'PK_SchT', 'PD_ProdNr', 'PD_TEB',
                      'PD_Stueck', 'PD_Auss_Ruest', 'PD_Auss_Prod', 'PD_Bemerk', 'PD_User', 'PD_ErfDat', 'PD_von', 'PD_bis', 'PD_Stoer', 'PD_Std', 'PD_Laenge',
                      'PD_Rf']
      INVALID_CSV_HEADERS=IMPORT_HEADERS + ['Error MSG']

      def self.import(file)
        msg = Message.new
        begin
          # validate_msg = validate_import(file)
          if true #validate_msg.result
            DowntimeRecord.transaction do
              CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
                row.strip
                # p row
                # p row.headers
                # p row.fields
                params = {}
                IMPORT_HEADERS.each { |header|
                  if header=='PD_ErfDat'
                    unless row[header].is_date?
                      right_keys = IMPORT_HEADERS - params.keys
                      right_values = row.fields[params.keys.count, row.fields.count]
                      right_values.each_with_index do |rv, index|
                        if rv.present? && rv.is_date?
                          right_values = right_values[index, right_values.count]
                          break
                        end
                      end
                      params = params.merge(right_keys.zip(right_values).to_h)
                      break
                    end
                  end
                  params[header] = row[header]
                }
                puts params
                puts '--------------------------------------------------------------------------------------'
                # MouldDetail.create(params)
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
        # if MouldDetail.find_by_mould_id(row['模具号'].to_i)
        #   msg.contents<<"该模具已存在！"
        # end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        return msg
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