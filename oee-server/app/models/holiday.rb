class Holiday < ApplicationRecord
  self.inheritance_column = :_type_disabled

  validates_presence_of :holiday, :message => "节假日不可为空!"
  validates_uniqueness_of :holiday, :message => "节假日已登记!"
end
