class Machine < ApplicationRecord
  validates_presence_of :nr, :message => "机器号不可为空!"
  validates_uniqueness_of :nr, :message => "机器号已存在!"

  belongs_to :machine_type
  belongs_to :department
end
