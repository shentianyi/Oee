class WorkTime < ApplicationRecord
  belongs_to :machine_type
  belongs_to :craft
end
