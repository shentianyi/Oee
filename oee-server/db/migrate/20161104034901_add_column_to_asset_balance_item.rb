class AddColumnToAssetBalanceItem < ActiveRecord::Migration[5.0]
  def change
    add_column :asset_balance_items, :asset_balance_list_id, :string
    add_index :asset_balance_items, :asset_balance_list_id
  end
end
