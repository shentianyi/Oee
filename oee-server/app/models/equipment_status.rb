class EquipmentStatus < ApplicationRecord
  scope :normal,->{where(group_id: EquipmentStatusGroupEnum::NORMAL).pluck(:id)}
  scope :scrap,->{where(group_id: EquipmentStatusGroupEnum::SCRAP).pluck(:id)}
end
