class AssetBalanceList < ApplicationRecord
  validates_uniqueness_of :id
  # after_initialize :generate_id
  before_create :generate_id

  has_many :asset_balance_items, dependent: :destroy

  def generate_id
    self.id = "ZC#{Time.now.strftime('%Y%m%d%H%M%S')}"
  end


  [
      :fix_asset_track_id, :cap_date, :profit_center, :asset_description, :acquis_val,
      :accum_dep, :book_val, :asset_class, :inventory_nr, :ts_equipment_nr, :ts_project,
      :ts_inventory_user_id, :ts_keeper, :ts_position, :ts_nameplate_track, :ts_type,
      :ts_equipment_type, :ts_area_id, :ts_supplier, :status, :remark, :ts_inventory_result, :is_move, :operation
  ]

  def to_report_xlsx
    p = Axlsx::Package.new
    wb = p.workbook
    BuManger.all.each do |b|
      abis = self.asset_balance_items.where(profit_center: b.id)
      if abis.size > 0
        wb.add_worksheet(:name => "#{b.nr}") do |sheet|
          headers = ["Type", "Asset", "Profit Ctr", "Class", "Cap.date", "Area", "Supplier", "Equ.No.", "Asset description"]
          projects = abis.pluck(:ts_project).uniq
          tails = ["Acquis. val.", "Accum. dep.", "Book. val."]
          sheet.add_row (headers+projects+tails)

          abis.each do |item|
            row = [
                              item.ts_equipment_type,
                              item.fix_asset_track.blank? ? '' : item.fix_asset_track.nr,
                              item.bu.blank? ? '' : item.bu.finance_nr,
                              item.asset_class,

                              item.cap_date.blank? ? '' : item.cap_date.localtime.strftime("%Y-%m-%d"),
                              item.ts_area.blank? ? '' : item.ts_area.name,
                              item.ts_supplier,
                              item.inventory_nr,
                              item.asset_description
                          ]
            row_2=[]
            projects.each do |p|
              p==item.ts_project ? (row_2<<'X') : (row_2<<'')
            end
            row+=row_2

            row+=[item.acquis_val, item.accum_dep, item.book_val]

            sheet.add_row row
          end
        end
      end
    end

    wb.add_worksheet(:name => "Summary") do |sheet|
      sheet.add_row ['BU', '6月份账面资产', 'Tooling', 'Common Equipment', 'Others']

      sum_items = self.asset_balance_items.select("SUM(asset_balance_items.book_val) as bu_total, asset_balance_items.*").group("asset_balance_items.profit_center")

      total = 0
      sum_items.each do |item|
        total+=item.bu_total
        sheet.add_row [item.bu.nr, item.bu_total]
      end
      sheet.add_row ['Total', total]
    end

    wb.add_worksheet(:name => "月度报告") do |sheet|
      cur_month = self.balance_date.localtime.strftime("%m").to_i
      pre_month = ((cur_month -1)==0) ? 12 : (cur_month -1)
      sheet.add_row ["#{self.balance_date.localtime.strftime("%Y")}年TS固定资产#{cur_month}月份月度报告"]
      sheet.add_row [
                        "当月月份-#{cur_month}月份",
                        "#{pre_month}月份账面资产金额",
                        "#{cur_month}月份账面资产金额",
                        "#{cur_month}月份账面转出金额"
                    ]
      data = {}

      sum_items = self.asset_balance_items.select("SUM(asset_balance_items.book_val) as bu_total, asset_balance_items.*").group("asset_balance_items.profit_center")
      total = 0
      sum_items.each do |item|
        total+=item.bu_total
        data[item.bu.nr] = {cur_month: item.bu_total}
      end
      data['Total'] = {cur_month: total}

      move_items = self.asset_balance_items.where(is_move: true)
                       .select("SUM(asset_balance_items.book_val) as bu_total, asset_balance_items.*").group("asset_balance_items.profit_center")
      total = 0
      move_items.each do |item|
        total+=item.bu_total
        if data[item.bu.nr].blank?
          data[item.bu.nr] = {move: item.bu_total}
        else
          data[item.bu.nr][:move] = item.bu_total
        end
      end
      data['Total'][:move] = total

      pre_list = AssetBalanceList.where("balance_date < ?", self.balance_date).first
      if pre_list
        pre_items = pre_list.asset_balance_items.select("SUM(asset_balance_items.book_val) as bu_total, asset_balance_items.*").group("asset_balance_items.profit_center")
        total = 0
        pre_items.each do |item|
          total+=item.bu_total
          if data[item.bu.nr].blank?
            data[item.bu.nr] = {pre: item.bu_total}
          else
            data[item.bu.nr][:pre] = item.bu_total
          end
        end

        data['Total'][:pre] = total
      end

      p data
      data.keys.each do |key|
        sheet.add_row [key, data[key][:pre], data[key][:cur_month], data[key][:move]]
      end

    end

    p.to_stream.read
  end
end
