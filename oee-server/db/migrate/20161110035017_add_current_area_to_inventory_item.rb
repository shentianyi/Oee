class AddCurrentAreaToInventoryItem < ActiveRecord::Migration[5.0]
  def change
    add_column :inventory_items, :current_area_id, :string
  end
end
