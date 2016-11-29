class InventoryList < ApplicationRecord
  belongs_to :asset_balance_list
  has_many :inventory_items, dependent: :destroy
  # has_many :user_area_items, dependent: :destroy
  has_many :user_inventory_tasks, dependent: :destroy

  after_create :init_inventory_items


  def init_inventory_items
    if self.asset_balance_list
      InventoryItem.transaction do
        self.asset_balance_list.asset_balance_items.each do |i|
          self.inventory_items.create({
                                          fix_asset_track_id: i.fix_asset_track_id,
                                          cap_date: i.cap_date,
                                          profit_center: i.profit_center,
                                          asset_description: i.asset_description,
                                          acquis_val: i.acquis_val,

                                          accum_dep: i.accum_dep,
                                          book_val: i.book_val,
                                          ts_equipment_nr: i.ts_equipment_nr,
                                          ts_project: i.ts_project,
                                          ts_keeper: i.ts_keeper,

                                          ts_position: i.ts_position,
                                          ts_nameplate_track: i.ts_nameplate_track,
                                          ts_type: i.ts_type,
                                          ts_equipment_type: i.ts_equipment_type,
                                          ts_area_id: i.ts_area_id,

                                          ts_supplier: i.ts_supplier,
                                          status: i.status,
                                          remark: i.remark,
                                          ts_inventory_result: i.ts_inventory_result
                                      })
        end
      end

    end
  end

  def has_un_covered_item
    self.inventory_items.where(is_cover: false).count>0
  end


  def generate_download_file user, type
    inventories=[]
    case type
      when FileUploadType::OVERALL
        inventories=self.inventory_items.where(ts_area_id: user.user_area_items.pluck(:area_id))
      when FileUploadType::RECOVERY
        inventories=self.inventory_items.where.not('ts_area_id <=> current_area_id')
    end

    InventoryFile.transaction do
      file=InventoryFile.new()

      File.open('uploadfiles/data/data.txt', 'w+') do |f|
        inventories.each do |i|
          ss = i.id.to_s + "," + i.fix_asset_track.nr.to_s + "," + i.ts_area_id.to_s + "\n"
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
