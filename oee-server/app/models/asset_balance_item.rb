class AssetBalanceItem < ApplicationRecord
  belongs_to :fix_asset_track
  belongs_to :asset_balance_list
end
