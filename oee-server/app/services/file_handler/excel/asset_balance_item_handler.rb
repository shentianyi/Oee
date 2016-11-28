module FileHandler
  module Excel
    class AssetBalanceItemHandler<Base

      HEADERS=[
          :fix_asset_track_id, :cap_date, :profit_center, :asset_description, :acquis_val,
          :accum_dep, :book_val, :asset_class, :inventory_nr, :ts_equipment_nr, :ts_project,
          :ts_inventory_user_id, :ts_keeper, :ts_position, :ts_nameplate_track, :ts_type,
          :ts_equipment_type, :ts_area_id, :ts_supplier, :status, :remark, :ts_inventory_result, :is_move, :operation
      ]

      def self.import(file, asset_balance_list)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg = validate_import(file, asset_balance_list)
        if validate_msg.result
          #validate file
          # begin
            count = 0
            AssetBalanceItem.transaction do
              2.upto(book.last_row) do |line|
                row = {}
                HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k] = row[k].sub(/\.0/, '') if k==:fix_asset_track_id
                end

                asset=FixAssetTrack.where(nr: row[:fix_asset_track_id], ancestry: nil).first
                area = Area.find_by_name(row[:ts_area_id])
                user = User.find_by_name(row[:ts_inventory_user_id])
                if user
                  row[:ts_inventory_user_id] = user.id
                end

                bu = BuManger.find_by_finance_nr(row[:profit_center])
                row[:profit_center] = bu.id


                count += 1
                item =AssetBalanceItem.new(row.except(:operation, :fix_asset_track_id, :ts_area_id))
                item.fix_asset_track = asset
                item.ts_area = area
                # item.ts_inventory_user = user
                item.asset_balance_list = asset_balance_list
                asset_balance_list.asset_balance_items<<item
                unless item.save
                  puts item.errors.to_json
                  raise item.errors.to_json
                end

              end
            end
            msg.result = true
            msg.content = "导入月资产平衡数据成功, #{count}条记录成功改变！"
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

      def self.validate_import file, asset_balance_list
        tmp_file=full_tmp_path(file.original_name)
        msg = Message.new(result: true)
        asset_nrs = []

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
              row[k] = row[k].sub(/\.0/, '') if k==:fix_asset_track_id
            end

            repeate_check=""
            if asset_nrs.include?(row[:fix_asset_track_id])
              repeate_check="/资产号：#{row[:fix_asset_track_id]}在数据文件中重复"
            else
              asset_nrs<<row[:fix_asset_track_id]
            end

            mssg = validate_row(row, asset_balance_list)
            if mssg.result && repeate_check.blank?
              sheet.add_row row.values
            else
              if msg.result
                msg.result = false
                msg.content = "下载错误文件<a href='/files/#{Base64.urlsafe_encode64(tmp_file)}'>#{::File.basename(tmp_file)}</a>"
              end
              sheet.add_row row.values<<(mssg.content.to_s+repeate_check)
            end
          end
        end
        p.use_shared_strings = true
        p.serialize(tmp_file)
        msg
      end

      def self.validate_row(row, asset_balance_list)
        msg = Message.new(contents: [])

        if row[:fix_asset_track_id].blank?
          msg.contents<<"资产号不可为空"
        else
          asset=FixAssetTrack.where(nr: row[:fix_asset_track_id], ancestry: nil).first
          if asset.blank?
            msg.contents<<"资产号不存在"
          else
            if asset_balance_list.asset_balance_items.pluck(:fix_asset_track_id).include?(asset.id)
              msg.contents<<"该清单中资产号：#{row[:fix_asset_track_id]}已存在"
            end
          end
        end

        if row[:ts_area_id].blank?
          msg.contents<<"TS使用区域不可为空"
        else
          unless area = Area.find_by_name(row[:ts_area_id])
            msg.contents<<"区域名：#{row[:ts_area_id]} 不存在"
          end
        end

        if row[:profit_center].blank?
          msg.contents<<"成本中心不可为空"
        else
          if BuManger.find_by_finance_nr(row[:profit_center]).blank?
            msg.contents<<"成本中心：#{row[:profit_center]} 不存在"
          end
        end

        # if row[:ts_inventory_user_id].blank?
        #   msg.contents<<"TS盘点员不可为空"
        # else
        #   unless user = User.find_by_name(row[:ts_inventory_user_id])
        #     msg.contents<<"盘点员：#{row[:ts_inventory_user_id]} 不存在"
        #   end
        # end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end
    end
  end
end