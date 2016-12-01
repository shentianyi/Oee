class FixAssetTrack < ApplicationRecord

  has_ancestry
  belongs_to :equipment_track
  has_many :asset_balance_items#, dependent: :destroy

  validates_uniqueness_of :equipment_nr, scope: :is_add_equipment, if: :new_equipment_and_asset
  validates_uniqueness_of :nr, scope: :is_add_equipment, if: :new_equipment_and_asset
  validate :exist_equipment_and_asset, if: :add_equipment_and_asset

  scope :to_do_list, -> { where(status: FixAssetStatus.to_do_list) }

  def new_equipment_and_asset
    !is_add_equipment
  end

  def add_equipment_and_asset
    is_add_equipment
  end

  def exist_equipment_and_asset
    if FixAssetTrack.where(nr: self.nr, equipment_nr: self.equipment_nr, is_add_equipment: false).first.blank?
      errors.add(:nr, "资产号：#{self.nr}且设备号：#{self.equipment_nr}不存在，不可追加")
    end
  end

  def self.to_xlsx assets
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row [
                        "序号", "资料接收日期", "物料采购申请单号", "名称及规格", "数量", "总价", "申请人", "采购日期", "供应商",	"使用费用(项目)",
                        "采购订单号",	"竣工单号", "是否追加到设备",	"设备编号",	"是否追加到资产",	"固定资产号",	"竣工单状态",	"备注"
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
                            asset.is_add_equipment ? 'Y' : 'N',
                            asset.equipment_nr,
                            asset.is_add_fix_asset ? 'Y' : 'N',

                            asset.nr,
                            FixAssetStatus.display(asset.status),
                            asset.remark
                        ]
      }
    end
    p.to_stream.read
  end

end