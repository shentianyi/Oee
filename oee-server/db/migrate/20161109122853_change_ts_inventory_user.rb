class ChangeTsInventoryUser < ActiveRecord::Migration[5.0]
  def change
    rename_column :asset_balance_items, :ts_inventory_user, :ts_inventory_user_id
    rename_column :inventory_items, :ts_inventory_user, :ts_inventory_user_id
  end
end
