class ChangeStatusOnEquipment < ActiveRecord::Migration[5.0]
  def change
    remove_column :equipment_tracks, :status
    add_column :equipment_tracks, :status, :integer, default: 6
  end
end
