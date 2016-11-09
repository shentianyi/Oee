class AddInventoryMarkToAssetBalanceItem < ActiveRecord::Migration[5.0]
  def change
    add_column :asset_balance_items, :lock_user_id, :string
    add_column :asset_balance_items, :lock_remark, :string
    add_column :asset_balance_items, :lock_at, :timestamp
    add_column :asset_balance_items, :lock_batch, :integer, default: 0
    add_column :asset_balance_items, :locked, :boolean, default: false
    add_index :asset_balance_items, :locked
  end
end
