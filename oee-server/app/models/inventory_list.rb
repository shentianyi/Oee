class InventoryList < ApplicationRecord

  belongs_to :asset_balance_list
  has_many :inventory_items, dependent: :destroy
  # has_many :user_area_items, dependent: :destroy
  has_many :user_inventory_tasks, dependent: :destroy

  before_validation :check_inventory_user
  after_create :init_inventory_items


  def check_inventory_user
    errors.add(:inventory_user_id, "尚有未分配盘点员的设备记录") if (EquipmentTrack.where("inventory_user_id is NULL").count > 0)
    errors.add(:rfid_nr, "尚有未贴RFID标签的设备记录") if (EquipmentTrack.where("rfid_nr is NULL").count > 0)
  end

  def init_inventory_items
    InventoryItem.transaction do
      EquipmentTrack.where.not(equip_create_way: EquipmentAddEnum::ADD_EQUIPMENT).each do |e|
        item = self.inventory_items.create({
                                                equipment_track_id: e.id,
                                                rfid_nr: e.rfid_nr,
                                                asset_nr: e.asset_nr,
                                                ts_equipment_nr: e.nr,
                                                ts_project: e.department,

                                                ts_area_id: e.ts_area_id,
                                                status: e.status,
                                                ts_nameplate_track: e.nameplate_track,
                                                ts_inventory_user_id: e.inventory_user_id
                                            })
        e.children.each do |i|
          child_itrm = item.children.create({
                                equipment_track_id: i.id,
                                rfid_nr: i.rfid_nr,
                                asset_nr: i.asset_nr,
                                ts_equipment_nr: i.nr,
                                ts_project: i.department,

                                ts_area_id: i.ts_area_id,
                                status: i.status,
                                ts_nameplate_track: i.nameplate_track,
                                ts_inventory_user_id: i.inventory_user_id
                            })
          self.inventory_items<<child_itrm
        end

      end
    end
  end

  # def init_inventory_items
  #   if self.asset_balance_list
  #     InventoryItem.transaction do
  #       self.asset_balance_list.asset_balance_items.each do |i|
  #         self.inventory_items.create({
  #                                         fix_asset_track_id: i.fix_asset_track_id,
  #                                         cap_date: i.cap_date,
  #                                         profit_center: i.profit_center,
  #                                         asset_description: i.asset_description,
  #                                         acquis_val: i.acquis_val,
  #
  #                                         accum_dep: i.accum_dep,
  #                                         book_val: i.book_val,
  #                                         ts_equipment_nr: i.ts_equipment_nr,
  #                                         ts_project: i.ts_project,
  #                                         ts_keeper: i.ts_keeper,
  #
  #                                         ts_position: i.ts_position,
  #                                         ts_nameplate_track: i.ts_nameplate_track,
  #                                         ts_type: i.ts_type,
  #                                         ts_equipment_type: i.ts_equipment_type,
  #                                         ts_area_id: i.ts_area_id,
  #
  #                                         ts_supplier: i.ts_supplier,
  #                                         status: i.status,
  #                                         remark: i.remark,
  #                                         ts_inventory_result: i.ts_inventory_result
  #                                     })
  #       end
  #     end
  #
  #   end
  # end

  def has_un_covered_item
    self.inventory_items.where(is_cover: false).count>0
  end


  def generate_download_file user, type
    inventories=[]
    case type
      when FileUploadType::OVERALL
        inventories=self.inventory_items.where(ts_inventory_user_id: user.id)
      when FileUploadType::RECOVERY
        inventories=self.inventory_items.where.not('ts_area_id <=> current_area_id')
    end

    InventoryFile.transaction do
      file=InventoryFile.new()

      File.open('uploadfiles/data/data.txt', 'w+') do |f|
        inventories.each do |i|
          ss = i.rfid_nr.to_s + "," + i.ts_project.to_s + "," + i.ts_area_id.to_s + "," + i.status.to_s + "\n"
          f.write(ss)
        end

        file.path = f
      end

      if file.save
        file
      else
        nil
      end
    end
  end

end
