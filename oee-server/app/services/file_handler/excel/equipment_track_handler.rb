module FileHandler
  module Excel
    class EquipmentTrackHandler<Base

      ZH_HEADERS=[
          "固定资产创建方式", "资产类型", "Asset", "Cap.date", "ProfitCenter", "设备名称", "设备编号", "型号/规格/配置", "Cutting生产编号", "设备序列号", "设备分级",
          "Asset Class", "设备使用部门", "TS 使用项目", "使用位置", "TS 盘点负责人", "保管人", "铭牌跟踪", "TS 类别", "TS 设备种类", "TS 使用区域", "TS 供应商", "Remark",
          "使用状态", "TS盘点结果", "操作指导书", "维护指导书", "工艺参数", "维护计划日历表", "故障停机", "大修计划及预测性维护", "说明书(Y/N)", "备件清单",
          "放行周期(年)", "预计再次放行时间", "放行提醒", "资产管理部门",
          "操作"
      ]

      # [
      #     "资产类型", :type, "Asset", :asset_nr, "ProfitCenter", :profit_center, "设备编号", :nr,"设备使用部门",:department,"TS 盘点负责人",:inventory_user_id,
      #     "TS 使用区域",:ts_area_id,"使用状态",:status,"资产管理部门",:asset_bu_id
      # ]

      # [
      #     'procurment_date->cap_date', :asset_class, "area->ts_area_id", :inventory_user_id, :keeper, :nameplate_track, :ts_type, :ts_equipment_type,:inventory_result,
      #     'Add:', :process_params, :maintain_plan, :machine_down, :big_maintain_plan, :instruction, :replacement_list,
      #     'responsibilityer->asset_bu_id'
      # ]

      HEADERS=[
          :equip_create_way, :type, :asset_nr, :cap_date, :profit_center, :name, :nr, :description, :product_id, :equipment_serial_id, :level,
          :asset_class, :department, :project, :location, :inventory_user_id, :keeper, :nameplate_track, :ts_type, :ts_equipment_type, :ts_area_id, :supplier, :remark,
          :status, :inventory_result, :operate_instructor, :maintain_instructor, :process_params, :maintain_plan, :machine_down, :big_maintain_plan, :instruction, :replacement_list,
          :release_cycle, :next_release, :release_notice, :asset_bu_id,
          :operation
      ]

      # HEADERS=[
      #     :level, :type, :asset_nr, :name, :nr, :description, :product_id, :equipment_serial_id, :supplier, :status,
      #     :profit_center, :department, :project, :location, :area, :operate_instructor, :maintain_instructor,
      #     :position, :procurment_date, :release_cycle, :next_release, :release_notice, :responsibilityer, :remark,
      #     :operation
      # ]

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
              # if validate_msg.object[:has_create]
              #   EquipmentTrack.where(is_top: true).update_all({is_top: false})
              # end

              2.upto(book.last_row) do |line|
                row = {}
                HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k] = row[k].sub(/\.0/, '') if [:asset_nr, :nr].include?(k)
                end

                p row

                row[:equip_create_way] = EquipmentAddEnum.decode(row[:equip_create_way])
                row[:type] = EquipmentType.decode(row[:type])
                if row[:department].present?
                  b=BuManger.find_by_nr(row[:department])
                  row[:department] = row[:profit_center] = b.id
                else
                  b=BuManger.find_by_finance_nr(row[:profit_center])
                  row[:department] = row[:profit_center] = b.id
                end
                row[:status] = EquipmentStatus.find_by_name(row[:status]).id
                if row[:inventory_user_id].present?
                  user = User.find_by_name(row[:inventory_user_id])
                  row[:inventory_user_id] = user.id
                end
                if row[:ts_area_id].present?
                  area = Area.find_by_name(row[:ts_area_id])
                  row[:ts_area_id] = area.id
                end
                if row[:asset_bu_id].present?
                  bb=BuManger.find_by_nr(row[:asset_bu_id])
                  row[:asset_bu_id] = bb.id
                end

                p row

                count += 1
                if ['update', 'UPDATE'].include?(row[:operation])
                  if row[:type] == EquipmentType::FIX_ASSET
                    e=EquipmentTrack.where(nr: row[:nr], asset_nr: row[:asset_nr], ancestry: nil).first
                  else
                    e=EquipmentTrack.find_by_nr(row[:nr])
                  end

                  e.update(row.except(:operation))
                elsif ['delete', 'DELETE'].include?(row[:operation])
                  if row[:type] == EquipmentType::FIX_ASSET
                    #TODO 追加的怎么删除？
                    e=EquipmentTrack.where(nr: row[:nr], asset_nr: row[:asset_nr], ancestry: nil).first
                  else
                    e=EquipmentTrack.find_by_nr(row[:nr])
                  end
                  e.destroy
                else
                  e =EquipmentTrack.new(row.except(:operation))
                  if row[:type] == EquipmentType::FIX_ASSET
                    fa = FixAssetTrack.where(nr: row[:asset_nr], ancestry: nil).first
                    e.fix_asset_track=fa
                  end

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
          sheet.add_row ZH_HEADERS+['Error Msg']
          #validate file
          2.upto(book.last_row) do |line|
            row = {}
            HEADERS.each_with_index do |k, i|
              row[k] = book.cell(line, i+1).to_s.strip
              row[k] = row[k].sub(/\.0/, '') if [:asset_nr, :nr].include?(k)
            end

            # row[:type] = EquipmentType.decode(row[:type])

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

          msg.object = {} if msg.object.blank?
        end
        p.use_shared_strings = true
        p.serialize(tmp_file)
        msg
      end

      def self.validate_row(row, line)
        msg = Message.new(contents: [])

        # if ['new', 'NEW'].include?(row[:operation]) || row[:operation].blank?
        #   msg.object = {has_create: true}
        # end

        unless row[:asset_bu_id].blank?
          if (bb=BuManger.find_by_nr(row[:asset_bu_id])).blank?
            msg.contents<<"资产管理部门#{row[:asset_bu_id]}不存在"
          end
        end

        if row[:ts_area_id].blank?
          # msg.contents<<"TS使用区域不可为空"
        else
          unless area = Area.find_by_name(row[:ts_area_id])
            msg.contents<<"使用区域：#{row[:ts_area_id]} 不存在"
          end
        end

        unless row[:inventory_user_id].blank?
          if (user = User.find_by_name(row[:inventory_user_id])).blank?
            msg.contents<<"盘点负责人:#{row[:inventory_user_id]}未找到"
          end
        end

        if row[:status].blank?
          msg.contents<<"设备使用状态不可为空"
        else
          if (s = EquipmentStatus.find_by_name(row[:status])).blank?
            msg.contents<<"设备使用状态:#{row[:status]}未找到"
          end
        end

        if row[:type].blank?
          msg.contents<<"资产类型不可为空"
        else
          if EquipmentType.get_type_names.include?(row[:type])
            if ['update', 'delete', 'UPDATE', 'DELETE'].include?(row[:operation])
              if row[:type] == EquipmentType.display(EquipmentType::FIX_ASSET)
                if row[:nr].blank? || row[:asset_nr].blank?
                  msg.contents<<"固定资产号或设备编号不可为空"
                else
                  if EquipmentTrack.where(nr: row[:nr], asset_nr: row[:asset_nr]).first.blank?
                    msg.contents<<"设备编号#{row[:nr]},固定资产号#{row[:asset_nr]}不存在"
                  end
                end
              else
                if EquipmentTrack.find_by_nr(row[:nr]).blank?
                  msg.contents<<"设备编号#{row[:nr]}不存在"
                end
              end
            else
              #new
              if row[:type] == EquipmentType.display(EquipmentType::FIX_ASSET)
                if row[:equip_create_way].blank?
                  msg.contents<<"固定资产新建方式不可为空"
                else
                  if EquipmentAddEnum.get_enum_names.include?(row[:equip_create_way])
                    if row[:nr].blank? || row[:asset_nr].blank?
                      msg.contents<<"固定资产号或设备编号不可为空"
                    else
                      if row[:equip_create_way]==EquipmentAddEnum.display(EquipmentAddEnum::CREATE_EQUIPMENT)
                        if EquipmentTrack.where(nr: row[:nr], asset_nr: row[:asset_nr]).first
                          msg.contents<<"设备编号#{row[:nr]},固定资产号#{row[:asset_nr]}已存在"
                        end

                        if FixAssetTrack.where(nr: row[:asset_nr], equipment_nr: row[:nr]).first.blank?
                          msg.contents<<"设备编号#{row[:nr]},固定资产号#{row[:asset_nr]}在竣工表中未找到"
                        end
                      elsif row[:equip_create_way]==EquipmentAddEnum.display(EquipmentAddEnum::ADD_EQUIPMENT)
                        if FixAssetTrack.where(nr: row[:asset_nr], equipment_nr: row[:nr]).first.blank?
                          msg.contents<<"设备编号#{row[:nr]},固定资产号#{row[:asset_nr]}在竣工表中未找到"
                        end

                        # if EquipmentTrack.where(nr: row[:nr], asset_nr: row[:asset_nr], equip_create_way: EquipmentAddEnum::CREATE_EQUIPMENT).first
                        #   msg.contents<<"设备编号#{row[:nr]},固定资产号#{row[:asset_nr]}主设备未添加"
                        # end
                      elsif row[:equip_create_way]==EquipmentAddEnum.display(EquipmentAddEnum::ONE_ASSET_SOME_EQUIPMENTS)
                        if EquipmentTrack.where(nr: row[:nr]).first
                          msg.contents<<"设备编号#{row[:nr]}已存在"
                        end

                        if FixAssetTrack.where(nr: row[:asset_nr], equipment_nr: row[:nr]).first.blank?
                          msg.contents<<"设备编号#{row[:nr]},固定资产号#{row[:asset_nr]}在竣工表中未找到"
                        end
                      end
                    end
                  else
                    msg.contents<<"固定资产新建方式只可选择以下值:#{EquipmentAddEnum.get_enum_names.join('|')}!"
                  end
                end
              else
                unless row[:asset_nr].blank?
                  if EquipmentTrack.find_by_asset_nr(row[:asset_nr])
                    msg.contents<<"固定资产号#{row[:asset_nr]}已存在"
                  end
                  if FixAssetTrack.find_by_nr(row[:asset_nr]).blank?
                    msg.contents<<"固定资产号#{row[:asset_nr]}在竣工表中未找到"
                  end
                end

                if row[:nr].blank?
                  msg.contents<<"设备编号不可为空"
                else
                  if FixAssetTrack.find_by_equipment_nr(row[:nr]).blank?
                    msg.contents<<"设备编号#{row[:nr]}在竣工表中未找到"
                  end

                  if EquipmentTrack.find_by_nr(row[:nr])
                    msg.contents<<"设备编号#{row[:nr]}已存在"
                  end
                end
              end
            end
          else
            msg.contents<<"资产类型只可选择以下值:#{EquipmentType.get_type_names.join('|')}!"
          end
        end

        if row[:profit_center].blank? || row[:department].blank?
          msg.contents<<"成本中心和设备使用部门不可为空"
        else
          unless row[:profit_center].blank?
            if (b1=BuManger.find_by_finance_nr(row[:profit_center])).blank?
              msg.contents<<"成本中心#{row[:profit_center]}不存在"
            end

            if (b2=BuManger.find_by_nr(row[:department])).blank?
              msg.contents<<"设备使用部门#{row[:department]}不存在"
            end

            if b1 && b2 && b1!=b2
              msg.contents<<"成本中心#{row[:profit_center]}和设备使用部门#{row[:department]}的对应关系不正确"
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