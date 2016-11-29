class FixAssetTrack < ApplicationRecord

  has_ancestry
  belongs_to :equipment_track
  has_many :asset_balance_items#, dependent: :destroy

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
                            asset.status,
                            asset.remark
                        ]
      }
    end
    p.to_stream.read
  end

end