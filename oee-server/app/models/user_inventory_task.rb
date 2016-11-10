class UserInventoryTask < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :user
  belongs_to :inventory_list
end
