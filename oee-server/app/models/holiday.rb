class Holiday < ApplicationRecord
  self.inheritance_column = :_type_disabled

  validates_presence_of :holiday, :message => "请输入完整的用户信息!"
  validates_uniqueness_of :holiday, :message => "节假日已登记!"
end
