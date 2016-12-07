class AddEquipmentIdToInventoryItem < ActiveRecord::Migration[5.0]
  def change
    add_column :inventory_items, :current_status, :string
    add_column :inventory_items, :current_project, :string
    add_column :inventory_items, :current_nameplate, :string
    add_column :inventory_items, :equipment_track_id, :integer
  end
end
