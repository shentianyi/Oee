class AddAncestryToInventoryItems < ActiveRecord::Migration[5.0]
  def change
    add_column :inventory_items, :ancestry, :string
    add_index :inventory_items, :ancestry
  end
end
