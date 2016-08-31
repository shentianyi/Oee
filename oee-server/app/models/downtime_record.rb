class DowntimeRecord < ApplicationRecord
  belongs_to :machine
  belongs_to :craft
  belongs_to :downtime_code
end
