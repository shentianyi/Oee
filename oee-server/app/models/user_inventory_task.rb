class UserInventoryTask < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :user
  belongs_to :inventory_list
  belongs_to :data_file, class_name: 'InventoryFile'
  belongs_to :error_file, class_name: 'InventoryFile'


  def update_inventory_data data, type
    msg=Message.new(contents: [])
    InventoryItem.transaction do
      unless data.blank?
        case type
          when FileUploadType::OVERALL
            data.each do |i|
              if (item = self.inventory_list.inventory_items.find_by_rfid_nr(i['rfid_nr'])).blank?
                msg.contents<<("盘点单：#{self.inventory_list.name}中未找到RFID：#{i['rfid_nr']}")
              else
                if item.update!(
                    current_area_id: i['current_area_id'],
                    current_status: i['current_status'],
                    current_project: i['current_project'],
                    current_nameplate: i['current_nameplate']
                )
                else
                  msg.contents<<("UPDATE RDID: #{i['rfid_nr']} DATA FAILED")
                end
              end
            end
          when FileUploadType::RECOVERY
            # data.each do |i|
            #   if i['id'].blank?
            #     msg.contents<<(i.to_s + "CAN NOT FIND THIS DATA'S [ID]")
            #   else
            #     inventory = Inventory.find_by_id(i['id'])
            #     if inventory.present?
            #       if inventory.update!(random_check_qty: i['random_check_qty'],
            #                            random_check_user: i['random_check_user'],
            #                            random_check_time: i['random_check_time'])
            #       else
            #         msg.contents<<(i.to_s + "UPDATE NEW DATA FAILED")
            #       end
            #     else
            #       msg.contents<<(i.to_s + "CAN NOT FIND THIS DATA")
            #     end
            #   end
            #
            #
            # end
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
      end
    end

    msg
  end
end
