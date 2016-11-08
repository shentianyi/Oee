module FileHandler
  module Excel
    class EquipmentTrackHandler<Base

      #设备分级	 设备类型	 资产编号 	设备名称	设备编号	型号规格配置	Cutting生产编号	 设备序列号	 供应商	使用状态	成本中心	使用部门	使用项目
      # 使用位置	区域 	操作指导书	维护指导书	说明书柜位	购置日期	放行周期(年)	预计再次放行时间	 放行提醒	 负责的工程师	 备注	操作

      HEADERS=[
          :level, :type, :asset_nr, :name, :nr, :description, :product_id, :equipment_serial_id, :supplier, :status, :profit_center, :department, :project,
          :location, :area, :operate_instructor, :maintain_instructor, :position, :procurment_date, :release_cycle, :next_release, :release_notice, :responsibilityer, :remark,  :operation
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
            EquipmentTrack.transaction do
              if validate_msg.object[:has_create]
                EquipmentTrack.where(is_top: true).update_all({is_top: false})
              end

              2.upto(book.last_row) do |line|
                row = {}
                HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k] = row[k].sub(/\.0/, '') if k== :asset_nr
                end

                p row

                count += 1
                if ['update', 'UPDATE'].include?(row[:operation]) && e=EquipmentTrack.find_by_nr(row[:nr])
                  e.update(row.except(:operation))
                elsif ['delete', 'DELETE'].include?(row[:operation]) && e=EquipmentTrack.find_by_nr(row[:nr])
                  e.destroy
                else
                  e =EquipmentTrack.new(row.except(:operation))
                  unless e.save
                    puts e.errors.to_json
                    raise e.errors.to_json
                  end
                end

              end
            end
            msg.result = true
            msg.content = "导入设备信息成功, #{count}条记录成功改变！"
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
        msg = Message.new(result: true, object: {})
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
              msg.object = mssg.object if msg.object.blank?
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

        if ['new', 'NEW'].include?(row[:operation]) || row[:operation].blank?
          msg.object = {has_create: true}
        end

        if row[:nr].blank?
          msg.contents<<"设备编号不可为空"
        else
          e=EquipmentTrack.find_by_nr(row[:nr])
          if ['update', 'delete', 'UPDATE', 'DELETE'].include?(row[:operation])
            if e.blank?
              msg.contents<<"设备编号:#{row[:nr]}未找到"
            end
          else
            if e.present?
              msg.contents<<"设备编号:#{row[:nr]}已存在，不可重复新建"
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