class InventoryItem < ApplicationRecord
  belongs_to :inventory_list
  belongs_to :fix_asset_track
  belongs_to :ts_area, class_name: 'Area'
  belongs_to :current_area, class_name: 'Area'
  belongs_to :ts_inventory_user, class_name: 'User'
  belongs_to :bu, class_name: 'BuManger', foreign_key: :profit_center

  def cover_item
    message = Message.new

    begin
      if self.inventory_list.asset_balance_list.asset_balance_items.where(fix_asset_track_id: self.fix_asset_track_id).first
        message.result = false
        message.content = "固定资产号：#{self.fix_asset_track.nr}重复，请确定是否已重置！"
      else
        self.inventory_list.asset_balance_list.asset_balance_items.create({
                                                                              fix_asset_track_id: self.fix_asset_track_id,
                                                                              cap_date: self.cap_date,
                                                                              profit_center: self.profit_center,
                                                                              asset_description: self.asset_description,
                                                                              acquis_val: self.acquis_val,

                                                                              accum_dep: self.accum_dep,
                                                                              book_val: self.book_val,
                                                                              ts_equipment_nr: self.ts_equipment_nr,
                                                                              ts_project: self.ts_project,
                                                                              ts_keeper: self.ts_keeper,

                                                                              ts_position: self.ts_position,
                                                                              ts_nameplate_track: self.ts_nameplate_track,
                                                                              ts_type: self.ts_type,
                                                                              ts_equipment_type: self.ts_equipment_type,
                                                                              ts_area_id: self.ts_area_id,

                                                                              ts_supplier: self.ts_supplier,
                                                                              status: self.status,
                                                                              remark: '盘点覆盖',
                                                                              ts_inventory_result: self.ts_inventory_result,
                                                                              inventory_nr: self.inventory_list.name,

                                                                              ts_inventory_user_id: self.ts_inventory_user_id
                                                                          })

        message.result = true
      end
    rescue => e
      message.result = false
      message.content = e.message
    end

    message
  end
end
