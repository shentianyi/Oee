class UserInventoryTaskService
  def self.create params, user, list
    UserInventoryTask.transaction do
      ft=UserInventoryTask.new({
                          user_id: user.id,
                          inventory_list_id: list.id,
                          start_time: params[:start_time],
                          end_time: params[:end_time],
                          real_qty: params[:real_qty],
                          target_qty: list.inventory_items.where(ts_area_id: user.user_area_items.pluck(:area_id)).count,
                          type: params[:type].to_i,
                          status: UserInventoryTaskStatus::OPEN
                      })

      file=InventoryFile.new()

      File.open('uploadfiles/data/data.json', 'w+') do |f|
        f.write(params[:data])
        file.path = f
      end

      ft.data_file=file

      if ft.save
        # FileTaskWorker.perform_async(ft.id)
        true
      else
        false
      end
    end
  end

  def self.update_inventory_data

  end

end