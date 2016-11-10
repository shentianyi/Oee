class Area < ApplicationRecord
  has_many :inventory_items
  has_many :asset_balance_items
end
