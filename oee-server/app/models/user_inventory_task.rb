class UserInventoryTask < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :user
  belongs_to :inventory_list
  belongs_to :data_file, class_name: 'InventoryFile'
  belongs_to :error_file, class_name: 'InventoryFile'
end
