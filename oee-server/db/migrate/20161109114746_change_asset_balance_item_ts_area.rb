class ChangeAssetBalanceItemTsArea < ActiveRecord::Migration[5.0]
  def change
    rename_column :asset_balance_items, :ts_area, :ts_area_id
  end
end
