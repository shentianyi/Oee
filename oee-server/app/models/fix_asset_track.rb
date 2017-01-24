class FixAssetTrack < ApplicationRecord

  has_ancestry
  belongs_to :equipment_track
  has_many :asset_balance_items#, dependent: :destroy

  validates_uniqueness_of :equipment_nr, scope: :equip_create_way, if: :new_equipment_and_asset
  validates_uniqueness_of :nr, scope: :equip_create_way, if: :new_equipment_and_asset
  validate :exist_equipment_and_asset, if: :add_equipment_and_asset
  after_update :sync_ts_pam_item

  scope :to_do_list, -> { where(status: FixAssetStatus.to_do_list) }

  def new_equipment_and_asset
    (equip_create_way==EquipmentAddEnum::CREATE_EQUIPMENT) && (equipment_nr!=nil)
  end

  def add_equipment_and_asset
    equip_create_way==EquipmentAddEnum::ADD_EQUIPMENT
  end

  def exist_equipment_and_asset
    if FixAssetTrack.where(nr: self.nr, equipment_nr: self.equipment_nr, equip_create_way: EquipmentAddEnum::CREATE_EQUIPMENT).first.blank?
      errors.add(:nr, "资产号：#{self.nr}且设备号：#{self.equipment_nr}不存在，不可追加")
    end
  end

  def sync_ts_pam_item
    if self.status_changed? && self.status==FixAssetStatus::DONE
      pam_item = PamItem.find_by_pa_no(self.apply_id)
      pam_item.update_attributes({
                                     completed_id: self.completed_id,
                                     completed_amount: (pam_item.completed_amount + self.price),
                                     completed_date: Time.now.localtime.strftime('%Y/%m/%d'),
                                     completed_status: FixAssetStatus.display(self.status)
                                 }) if pam_item
    end
  end

  def self.to_xlsx assets
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row [
                        "序号", "资料接收日期", "物料采购申请单号", "名称及规格", "数量", "总价", "申请人", "采购日期", "供应商",	"使用费用(项目)",
                        "采购订单号",	"竣工单号", "在建工程号", "资产创建方式",	"设备编号",	"固定资产号",	"竣工单状态",	"备注"
                    ]
      assets.each_with_index { |asset, index|
          sheet.add_row [
                            index+1,
                            asset.info_receive_date.blank? ? '' : asset.info_receive_date.localtime.strftime("%Y-%m-%d"),
                            asset.apply_id,
                            asset.description,
                            asset.qty,

                            asset.price,
                            asset.proposer,
                            asset.procurment_date.blank? ? '' : asset.procurment_date.localtime.strftime("%Y-%m-%d"),
                            asset.supplier,
                            asset.project,

                            asset.procurment_id,
                            asset.completed_id,
                            asset.processing_id,
                            EquipmentAddEnum.display(asset.equip_create_way),
                            asset.equipment_nr,
                            asset.nr,

                            FixAssetStatus.display(asset.status),
                            asset.remark
                        ]
      }
    end
    p.to_stream.read
  end

end