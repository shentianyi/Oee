class AssetBalanceItem < ApplicationRecord
  belongs_to :fix_asset_track
  belongs_to :asset_balance_list
  belongs_to :ts_area, class_name: 'Area'
  belongs_to :ts_inventory_user, class_name: 'User'
  belongs_to :bu, class_name: 'BuManger', foreign_key: :profit_center

  default_scope { where(locked: false) }
end
