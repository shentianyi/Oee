module FileHandler
  module Excel
    class WorkTimeHandler<Base
      HEADERS=[
          'machine_type_id', 'craft_id', 'wire_length', 'std_time', 'operation'
      ]

      def self.import(file)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg = validate_import(file)
        if validate_msg.result
          #validate file
          begin
            count = 0
            User.transaction do
              2.upto(book.last_row) do |line|
                row = {}
                HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k] = row[k].sub(/\.0/, '') if k=='oee_nr'
                end

                mt = MachineType.find_by_nr(row['machine_type_id'])
                craft = Craft.find_by_nr(row['craft_id'])
                row['machine_type_id'] = mt.id
                row['craft_id'] = craft.id

                count += 1
                if ['update', 'UPDATE'].include?(row['operation']) && wt = WorkTime.where(machine_type_id: mt.id, craft_id: craft.id, wire_length: row['wire_length'].to_f).first
                  wt.update(row.except('operation'))
                elsif ['delete', 'DELETE'].include?(row['operation']) && wt = WorkTime.where(machine_type_id: mt.id, craft_id: craft.id, wire_length: row['wire_length'].to_f).first
                  wt.destroy
                else
                  s =WorkTime.new(row.except('operation'))
                  unless s.save
                    puts s.errors.to_json
                    raise s.errors.to_json
                  end
                end
              end
            end
            msg.result = true
            msg.content = "导入标准工时信息成功, #{count}条记录成功改变！"
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

        mt = nil
        if row['machine_type_id'].blank?
          msg.contents<<"机器类型不可为空"
        else
          unless mt=MachineType.find_by_nr(row['machine_type_id'])
            msg.contents<<"机器类型:#{row['machine_type_id']}不存在"
          end
        end

        craft=nil
        if row['craft_id'].blank?
          msg.contents<<"工艺号不可为空"
        else
          unless craft=Craft.find_by_nr(row['craft_id'])
            msg.contents<<"工艺号:#{row['craft_id']}已存在"
          end
        end

        if row['wire_length'].blank?
          msg.contents<<"线长不可为空"
        end

        unless ['delete', 'DELETE'].include?(row['operation'])
          if row['std_time'].blank?
            msg.contents<<"工时不可为空"
          else
            if row['std_time'].to_f <= 0
              msg.contents<<"工时不合法"
            end
          end
        end

        if mt && craft && row['wire_length'].present?
          wt = WorkTime.where(machine_type_id: mt.id, craft_id: craft.id, wire_length: row['wire_length'].to_f).first
          if ['update', 'delete', 'UPDATE', 'DELETE'].include?(row['operation'])
            if wt.blank?
              msg.contents<<"机器类型：#{row['machine_type_id']}-工艺号：#{row['craft_id']}-线长：#{row['wire_length']}对应的标准工时未找到"
            end
          else
            if wt.present?
              msg.contents<<"机器类型：#{row['machine_type_id']}-工艺号：#{row['craft_id']}-线长：#{row['wire_length']}对应的标准工时已存在"
            end
          end
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end
    end
  end
end