class EquipmentTrack < ApplicationRecord
  self.inheritance_column = :_type_disabled

  validates_uniqueness_of :nr, :message => "设备名称已存在!"

  has_many :equipment_depreciations, :dependent => :destroy
  has_many :equipment_releases, :dependent => :destroy
  has_one :fix_asset_track, :dependent => :destroy


end
