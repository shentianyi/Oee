class AssetBalanceItem < ApplicationRecord
  belongs_to :fix_asset_track
  belongs_to :asset_balance_list

  default_scope { where(locked: false) }
end
