class MachineType < ApplicationRecord
  validates_presence_of :nr, :message => "机器类型不可为空!"
end
