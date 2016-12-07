class AddAssetNrToInventoryItem < ActiveRecord::Migration[5.0]
  def change
    add_column :inventory_items, :asset_nr, :string
  end
end
