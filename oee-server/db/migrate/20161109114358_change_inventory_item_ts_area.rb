class ChangeInventoryItemTsArea < ActiveRecord::Migration[5.0]
  def change
    rename_column :inventory_items, :ts_area, :ts_area_id
  end
end
