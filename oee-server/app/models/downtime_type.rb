class DowntimeType < ApplicationRecord
  validates_presence_of :nr, :message => "停机类型编号不可为空!"
  validates_uniqueness_of :nr, :message => "停机类型编号已存在!"
  validates_presence_of :name, :message => "停机类型名称不可为空!"
  validates_uniqueness_of :name, :message => "停机类型名称已存在!"
end
