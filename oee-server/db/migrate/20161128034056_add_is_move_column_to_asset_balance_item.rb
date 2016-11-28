class AddIsMoveColumnToAssetBalanceItem < ActiveRecord::Migration[5.0]
  def change
    add_column :asset_balance_items, :is_move, :boolean, default: false
  end
end
