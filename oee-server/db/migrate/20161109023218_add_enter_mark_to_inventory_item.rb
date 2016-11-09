class AddEnterMarkToInventoryItem < ActiveRecord::Migration[5.0]
  def change
    add_column :inventory_items, :is_cover, :boolean, default: false
    add_index :inventory_items, :is_cover

    add_column :inventory_lists, :status, :integer, default: 100
    add_index :inventory_lists, :status
  end
end
