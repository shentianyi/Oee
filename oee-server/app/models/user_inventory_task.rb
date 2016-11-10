class UserInventoryTask < ApplicationRecord
  belongs_to :user
  belongs_to :inventory_list
end
