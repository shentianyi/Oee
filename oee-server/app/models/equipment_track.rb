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


  after_create :check_uniq_rfid

  scope :normal, -> { where(status: EquipmentStatus.normal) }
  scope :scrap, -> { where(status: EquipmentStatus.scrap) }

  def check_uniq_rfid
    if self.rfid_nr.present? && EquipmentTrack.where(rfid_nr: self.rfid_nr)
      errors.add(:rfid_nr, "RFID：#{self.rfid_nr}已存在，不可重复!")
    end
  end

  def self.download_to_xlsx
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row [
                        "RFID编号", "固定资产创建方式", "资产类型", "Asset", "Cap.date", "ProfitCenter", "设备名称", "设备编号", "型号/规格/配置", "Cutting生产编号", "设备序列号",
                        "设备分级", "Asset Class", "设备使用部门", "TS 使用项目", "使用位置", "TS 盘点负责人", "保管人", "铭牌跟踪", "TS 类别", "TS 设备种类", "TS 使用区域	",
                        "TS 供应商", "Remark", "使用状态", "TS盘点结果", "操作指导书", "维护指导书", "工艺参数", "维护计划日历表", "故障停机", "大修计划及预测性维护", "说明书(Y/N)",
                        "备件清单", "放行周期(年)", "预计再次放行时间", "放行提醒", "资产管理部门", "操作"
                    ]

      EquipmentTrack.all.each_with_index { |equipment, index|
        row = [
            equipment.rfid_nr,
            EquipmentAddEnum.display(equipment.equip_create_way),
            EquipmentType.display(equipment.type),
            equipment.asset_nr,
            equipment.cap_date.localtime.strftime("%Y/%m/%d"),
            equipment.finance_bu.blank? ? '' : equipment.finance_bu.finance_nr,
            equipment.name,
            equipment.nr,
            equipment.description,
            equipment.product_id,
            equipment.equipment_serial_id,
            equipment.level,
            equipment.asset_class,
            equipment.ts_bu.blank? ? '' : equipment.ts_bu.nr,
            equipment.project,
            equipment.location,
            equipment.inventory_user.blank? ? '' : equipment.inventory_user.name,
            equipment.keeper,
            equipment.nameplate_track,
            equipment.ts_type,
            equipment.ts_equipment_type,
            equipment.ts_area.blank? ? '' : equipment.ts_area.name,
            equipment.supplier,
            equipment.remark,
            equipment.equipment_status.blank? ? '' : equipment.equipment_status.name,
            equipment.inventory_result,
            equipment.operate_instructor,
            equipment.maintain_instructor,
            equipment.process_params,
            equipment.maintain_plan,
            equipment.machine_down,
            equipment.big_maintain_plan,
            equipment.instruction,
            equipment.replacement_list,
            equipment.release_cycle,
            equipment.next_release,
            equipment.release_notice,
            equipment.asset_manager_bu.blank? ? '' : equipment.asset_manager_bu.nr,
            'UPDATE'
        ]

        sheet.add_row row, :types => [:string]
      }
    end
    p.to_stream.read
  end
  [
      "RFID编号", "固定资产创建方式", "资产类型", "Asset", "Cap.date", "ProfitCenter", "设备名称", "设备编号", "型号/规格/配置", "Cutting生产编号", "设备序列号",
      "设备分级", "Asset Class", "设备使用部门", "TS 使用项目", "使用位置", "TS 盘点负责人", "保管人", "铭牌跟踪", "TS 类别", "TS 设备种类", "TS 使用区域	",
      "TS 供应商", "Remark", "使用状态", "TS盘点结果", "操作指导书", "维护指导书", "工艺参数", "维护计划日历表", "故障停机", "大修计划及预测性维护", "说明书(Y/N)",
      "备件清单", "放行周期(年)", "预计再次放行时间", "放行提醒", "资产管理部门", "操作"
  ]
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
                        "RFID编号", "固定资产创建方式", "资产类型", "Asset", "Cap.date", "ProfitCenter", "设备名称", "设备编号", "型号/规格/配置", "Cutting生产编号", "设备序列号",
                        "设备分级", "Asset Class", "设备使用部门", "TS 使用项目", "使用位置", "TS 盘点负责人", "保管人", "铭牌跟踪", "TS 类别", "TS 设备种类", "TS 使用区域	",
                        "TS 供应商", "Remark", "使用状态", "TS盘点结果", "操作指导书", "维护指导书", "工艺参数", "维护计划日历表", "故障停机", "大修计划及预测性维护", "说明书(Y/N)",
                        "备件清单", "放行周期(年)", "预计再次放行时间", "放行提醒", "资产管理部门",
                        "GAAP Acquis.val.", "GAAP Accum.dep.", "GAAP Book.val.","IFRS Acquis.val.", "IFRS Accum.dep.", "IFRS Book.val.",
                        "首次放行", "再次放行1", "再次放行2", "再次放行3", "再次放行4", "再次放行5", "再次放行6", "再次放行7", "再次放行8", "再次放行9",
                    ]

      equipments.each_with_index { |equipment, index|
        row_1 = [
            equipment.rfid_nr,
            EquipmentAddEnum.display(equipment.equip_create_way),
            EquipmentType.display(equipment.type),
            equipment.asset_nr,
            equipment.cap_date.localtime.strftime("%Y/%m/%d"),
            equipment.finance_bu.blank? ? '' : equipment.finance_bu.finance_nr,
            equipment.name,
            equipment.nr,
            equipment.description,
            equipment.product_id,
            equipment.equipment_serial_id,
            equipment.level,
            equipment.asset_class,
            equipment.ts_bu.blank? ? '' : equipment.ts_bu.nr,
            equipment.project,
            equipment.location,
            equipment.inventory_user.blank? ? '' : equipment.inventory_user.name,
            equipment.keeper,
            equipment.nameplate_track,
            equipment.ts_type,
            equipment.ts_equipment_type,
            equipment.ts_area.blank? ? '' : equipment.ts_area.name,
            equipment.supplier,
            equipment.remark,
            equipment.equipment_status.blank? ? '' : equipment.equipment_status.name,
            equipment.inventory_result,
            equipment.operate_instructor,
            equipment.maintain_instructor,
            equipment.process_params,
            equipment.maintain_plan,
            equipment.machine_down,
            equipment.big_maintain_plan,
            equipment.instruction,
            equipment.replacement_list,
            equipment.release_cycle,
            equipment.next_release,
            equipment.release_notice,
            equipment.asset_manager_bu.blank? ? '' : equipment.asset_manager_bu.nr,
        ]

        row_2 = []
        if equipment_depreciation = equipment.equipment_depreciations.last
          row_2 = [equipment_depreciation.original_val, equipment_depreciation.depreciation_val, equipment_depreciation.net_val, equipment_depreciation.acquis_val, equipment_depreciation.accum_val, equipment_depreciation.book_val]
        else
          row_2 = ['', '', '', '', '', '']
        end

        row_3 = Array.new(10, '')
        equipment.equipment_releases.each_with_index { |r, index| row_3[index]=r.release_time.localtime.strftime('%Y/%m/%d') }

        sheet.add_row (row_1 + row_2 + row_3), :types => [:string]
      }
    end
    p.to_stream.read
  end
end
