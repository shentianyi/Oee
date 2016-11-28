class EquipmentTrack < ApplicationRecord
  self.inheritance_column = :_type_disabled

  validates_presence_of :nr, :message => "设备名称不可为空!"
  validates_uniqueness_of :nr, :message => "设备名称已存在!"

  has_many :equipment_depreciations, :dependent => :destroy
  has_many :equipment_releases, :dependent => :destroy
  has_one :fix_asset_track, :dependent => :destroy
  belongs_to :equipment_status, class_name: 'EquipmentStatus', foreign_key: :status


  scope :normal,->{where(status: EquipmentStatus.normal)}
  scope :scrap,->{where(status: EquipmentStatus.scrap)}


end
