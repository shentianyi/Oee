class Department < ApplicationRecord
  validates_presence_of :nr, :message => "部门号不可为空!"
end
