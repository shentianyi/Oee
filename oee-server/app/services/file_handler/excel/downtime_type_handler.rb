module FileHandler
  module Excel
    class DowntimeTypeHandler<Base
      HEADERS=[
          'nr', 'name', 'description', 'operation'
      ]

      def self.import(file)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg = validate_import(file)
        if validate_msg.result
          #validate file
          begin
            User.transaction do
              2.upto(book.last_row) do |line|
                row = {}
                HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k] = row[k].sub(/\.0/, '') if k=='nr'
                end

                if ['update', 'UPDATE'].include?(row['operation']) && DowntimeType.find_by_nr(row['nr'])
                  m.update(row.except('operation'))
                elsif ['delete', 'DELETE'].include?(row['operation']) && DowntimeType.find_by_nr(row['nr'])
                  m.destroy
                else
                  unless DowntimeType.find_by_nr(row['nr'])
                    s = DowntimeType.new(row.except('operation'))
                    unless s.save
                      puts s.errors.to_json
                      raise s.errors.to_json
                    end
                  end
                end
              end
            end
            msg.result = true
            msg.content = "导入停机类型信息成功！"
          rescue => e
            puts e.backtrace
            msg.result = false
            msg.content = e.message
          end
        else
          msg.result = false
          msg.content = validate_msg.content
        end
        msg
      end

      def self.validate_import file
        tmp_file=full_tmp_path(file.original_name)
        msg = Message.new(result: true)
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
          sheet.add_row HEADERS+['Error Msg']
          #validate file
          2.upto(book.last_row) do |line|
            row = {}
            HEADERS.each_with_index do |k, i|
              row[k] = book.cell(line, i+1).to_s.strip
            end

            mssg = validate_row(row, line)
            if mssg.result
              sheet.add_row row.values
            else
              if msg.result
                msg.result = false
                msg.content = "下载错误文件<a href='/files/#{Base64.urlsafe_encode64(tmp_file)}'>#{::File.basename(tmp_file)}</a>"
              end
              sheet.add_row row.values<<mssg.content
            end
          end
        end
        p.use_shared_strings = true
        p.serialize(tmp_file)
        msg
      end

      def self.validate_row(row, line)
        msg = Message.new(contents: [])

        if row['nr'].blank?
          msg.contents<<"停机类型编号不可为空"
        else
          m=DowntimeType.find_by_nr(row['nr'])
          if ['update', 'delete', 'UPDATE', 'DELETE'].include?(row['operation'])
            if m.blank?
              msg.contents<<"停机类型编号:#{row['nr']}未找到"
            end
          else
            if m.present?
              msg.contents<<"停机类型编号:#{row['nr']}已存在"
            end
          end
        end

        if row['name'].blank?
          msg.contents<<"停机类型名称不可为空"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end
    end
  end
end