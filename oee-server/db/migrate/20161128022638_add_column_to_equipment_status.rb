class AddColumnToEquipmentStatus < ActiveRecord::Migration[5.0]
  def change
    add_column :equipment_statuses, :group_id, :integer, default: 100

  end
end
