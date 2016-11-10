class AssetBalanceItem < ApplicationRecord
  belongs_to :fix_asset_track
  belongs_to :asset_balance_list
  belongs_to :ts_area, class_name: 'Area'
  belongs_to :ts_inventory_user, class_name: 'User'

  default_scope { where(locked: false) }
end
