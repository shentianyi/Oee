class EquipmentTrack < ApplicationRecord
  self.inheritance_column = :_type_disabled

  has_ancestry

  validates_presence_of :nr, :message => "设备编号不可为空!"
  validates_presence_of :rfid_nr, :message => "RFID不可为空!"
  # validates_presence_of :asset_nr, :message => "资产编号不可为空!"
  # validates_uniqueness_of :nr, :message => "设备名称已存在!"

  has_many :equipment_depreciations, :dependent => :destroy
  has_many :equipment_releases, :dependent => :destroy
  has_one :fix_asset_track#, :dependent => :destroy
  belongs_to :equipment_status, class_name: 'EquipmentStatus', foreign_key: :status
  belongs_to :finance_bu, class_name: 'BuManger', foreign_key: :profit_center
  belongs_to :ts_bu, class_name: 'BuManger', foreign_key: :department
  belongs_to :ts_area, class_name: 'Area'
  belongs_to :inventory_user, class_name: 'User'
  belongs_to :asset_manager_bu, class_name: 'BuManger', foreign_key: :asset_bu_id


  validate :check_uniq_rfid

  scope :normal, -> { where(status: EquipmentStatus.normal) }
  scope :scrap, -> { where(status: EquipmentStatus.scrap) }

  def check_uniq_rfid
    if self.rfid_nr.present? && EquipmentTrack.find_by_rfid_nr(self.rfid_nr)
      errors.add(:rfid_nr, "RFID：#{self.rfid_nr}已存在，不可重复!")
    end
  end

  def self.to_xlsx equipments
    # head1 = ["序号", "设备分级", "设备类型", "资产编号", "设备名称", "设备编号", "型号规格配置", "Cutting生产编号", "设备序列号", "供应商", "使用状态", "成本中心",
    #          "使用部门", "使用项目", "使用位置", "区域", "操作指导书", "维护指导书", "说明书柜位"]
    #
    # head3 = ["购置日期"]
    #
    # head5 = ["放行周期(年)", "预计再次放行时间", "放行提醒", "负责的工程师", "备注"]

    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row [
                        "序号", "设备分级", "设备类型", "资产编号", "设备名称", "设备编号", "型号规格配置", "Cutting生产编号", "设备序列号", "供应商", "使用状态", "成本中心",
                        "使用部门", "使用项目", "使用位置", "区域", "操作指导书", "维护指导书", "说明书柜位",
                        "原值", "折旧", "净值",
                        "购置日期",
                        "首次放行", "再次放行1", "再次放行2", "再次放行3", "再次放行4", "再次放行5", "再次放行6", "再次放行7", "再次放行8", "再次放行9",
                        "放行周期(年)", "预计再次放行时间", "放行提醒", "负责的工程师", "备注"
                    ]

      equipments.each_with_index { |equipment, index|
        row_1 = [
            index+1,
            equipment.level,
            EquipmentType.display(equipment.type),
            equipment.asset_nr,
            equipment.name,

            equipment.nr,
            equipment.description,
            equipment.product_id,
            equipment.equipment_serial_id,
            equipment.supplier,

            equipment.equipment_status.blank? ? '' : equipment.equipment_status.name,
            equipment.finance_bu.blank? ? '' : equipment.finance_bu.finance_nr,
            equipment.ts_bu.blank? ? '' : equipment.ts_bu.nr,
            equipment.project,
            equipment.location,

            equipment.area,
            equipment.operate_instructor,
            equipment.maintain_instructor,
            equipment.position
        ]

        row_2 = []
        if equipment_depreciation = equipment.equipment_depreciations.last
          row_2 = [equipment_depreciation.original_val, equipment_depreciation.depreciation_val, equipment_depreciation.net_val]
        else
          row_2 = ['', '', '']
        end

        row_3 = [
            equipment.procurment_date.blank? ? '' : equipment.procurment_date.localtime.strftime("%Y-%m-%d")
        ]

        row_4 = Array.new(10, '')
        equipment.equipment_releases.each_with_index { |r, index| row_4[index]=r.release_time.localtime.strftime('%Y/%m/%d') }

        row_5 = [
            equipment.release_cycle,
            equipment.next_release,
            equipment.release_notice,
            equipment.responsibilityer,
            equipment.remark
        ]

        sheet.add_row (row_1 + row_2 + row_3 + row_4 + row_5), :types => [:string]
      }
    end
    p.to_stream.read
  end
end
