module FileHandler
  module Excel
    class FixAssetTrackHandler<Base

      HEADERS=[
          :info_receive_date, :apply_id, :description, :qty, :price, :proposer, :procurment_date, :supplier,
          :project, :procurment_id, :completed_id, :equip_create_way, :equipment_nr, :nr, :processing_id,
          :status, :remark
      ]

      def self.import(file)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg = validate_import(file)
        if validate_msg.result
          #validate file
          # begin
            count = 0
            EquipmentTrack.transaction do
              2.upto(book.last_row) do |line|
                row = {}
                HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k] = row[k].sub(/\.0/, '') if [:nr, :equipment_nr, :apply_id, :procurment_id, :processing_id].include?(k)
                end

                row[:equip_create_way] = EquipmentAddEnum.decode(row[:equip_create_way])
                row[:status] = FixAssetStatus.decode(row[:status])

                p row

                count += 1

                if row[:equip_create_way]==EquipmentAddEnum::ADD_EQUIPMENT
                  pf = FixAssetTrack.find_by_nr(row[:nr])
                  f = pf.children.new(row.except(:operation))
                elsif row[:equip_create_way]==EquipmentAddEnum::CREATE_EQUIPMENT
                  f =FixAssetTrack.new(row.except(:operation))
                elsif row[:equip_create_way]==EquipmentAddEnum::ONE_ASSET_SOME_EQUIPMENTS
                  f =FixAssetTrack.new(row.except(:operation))
                end

                unless f.save
                  puts f.errors.to_json
                  raise f.errors.to_json
                end
              end
            end
            msg.result = true
            msg.content = "导入固定资产信息成功, #{count}条记录成功改变！"
          # rescue => e
          #   puts e.backtrace
          #   msg.result = false
          #   msg.content = e.message
          # end
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
              row[k] = row[k].sub(/\.0/, '') if [:nr, :equipment_nr, :apply_id, :procurment_id, :processing_id].include?(k)
            end

            # row[:equip_create_way] = EquipmentAddEnum.decode(row[:equip_create_way])

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

        if row[:apply_id].blank?
          msg.contents<<"物资采购申请单号不可为空"
        end

        if row[:nr].blank? || row[:equipment_nr].blank?
          msg.contents<<"固定资产编号或设备编号不可为空"
        else
          if EquipmentAddEnum.get_enum_names.include?(row[:equip_create_way])
            if row[:equip_create_way]==EquipmentAddEnum.display(EquipmentAddEnum::ADD_EQUIPMENT)
              if FixAssetTrack.where(nr: row[:nr], equipment_nr: row[:equipment_nr], equip_create_way: EquipmentAddEnum::CREATE_EQUIPMENT).first.blank?
                msg.contents<<"固定资产编号：#{row[:nr]}且设备编号：#{row[:equipment_nr]}不存在, 不可追加"
              end
            else
              if FixAssetTrack.where(nr: row[:nr], equipment_nr: row[:equipment_nr], equip_create_way: EquipmentAddEnum::CREATE_EQUIPMENT).first
                msg.contents<<"固定资产编号：#{row[:nr]}且设备编号：#{row[:equipment_nr]}已存在"
              end
            end
          else
            msg.contents<<"固定资产新建方式只可选择以下值:#{EquipmentAddEnum.get_enum_names.join('|')}!"
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