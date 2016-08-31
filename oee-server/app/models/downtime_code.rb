class DowntimeCode < ApplicationRecord
  validates_presence_of :nr, :message => "停机代码不可为空!"
  validates_uniqueness_of :nr, :message => "停机代码已存在!"
  validates_presence_of :downtime_type_id, :message => "停机类型不可为空!"

  belongs_to :downtime_type
end
