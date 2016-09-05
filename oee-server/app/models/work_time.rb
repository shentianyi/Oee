class WorkTime < ApplicationRecord
  belongs_to :machine_type
  belongs_to :craft


  def self.wire_length_level length
    (i=(length.to_f/500.0).round)==0 ? 5 : i * 5
  end

  def self.search_work_time machine_type, craft, length
    if machine_type.blank? || craft.blank?
      return 0
    end

    if work_time=WorkTime.where(machine_type_id: machine_type.id, craft_id: craft.id, wire_length: wire_length_level(length)).first
      work_time.std_time
    else
      0
    end
  end

end
