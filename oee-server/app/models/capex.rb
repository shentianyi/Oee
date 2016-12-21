class Capex < ApplicationRecord
  belongs_to :bu, class_name: 'BuManger', foreign_key: :bu_code
  has_many :budgets, dependent: :destroy
  # has_many :budget_items, through: :budgets
  accepts_nested_attributes_for :budgets, :allow_destroy => true


  def calc_percent t1, t2
    t2==0 ? '-' : (((t1.to_f/t2)*100).to_s+'%')
  end

  def sum_budget index
    self.budgets.map { |b| b.budget_items[index].blank? ? 0 : b.budget_items[index].total_price }.reduce(0) { |bt, bv| bt += bv.to_f }
  end

  def sum_pams_column column
    self.budgets.map { |b| b.pam_lists.pluck(column).reduce(0) { |total, val| total += val.to_f } }.reduce(0) { |t, v| t+=v }
  end

  def sum_pam_items_cloumn column
    self.budgets.map { |b| b.pam_lists.map { |l| l.pam_items.pluck(column).reduce(0) { |lt, lv| lt+=lv.to_f } }.reduce(0) { |it, iv| it+=iv.to_f } }.reduce(0) { |t, v| t+=v.to_f }
  end

  def self.to_xlsx capexes
    p = Axlsx::Package.new
    wb = p.workbook
    BuManger.all.each do |b|
      cs = capexes.where(bu_code: b.id)
      if cs.size>0
        wb.add_worksheet(:name => "#{b.nr}") do |sheet|
          sheet.add_row [
                            "序号", "Project", "Budget code", "Type", "Description", "Qty", "Unit price", "Total Price", "FC1 Qty", "FC1 Unit price",

                            "FC1 Total Price", "FC2 Qty", "FC2 Unit price", "FC3 Total Price", "PAM Number PAM号", "PAM Cost PAM申请金额",
                            "remained 批准PAM剩余金额", "PAM Final approved", "PAM批准状态", "PAM in process 申请中预算", "Approved PAM 已批准预算", #PAM Final approved", "PAM批准状态  一个字段分开了

                            "Budget not applied 未申请预算", "PA No. 请购单号", "Description 描述", "Qty 数量", "Total cost 申请总价",
                            "applicant 请购人", "Date请购日期", "Supplier 供应商", "SAP No. SAP 号", "Arrive date 预估到货时间 [CW]",

                            "Final Release (Y/N) 请购单签完字", "PO No. 采购订单号 ", "PO Cost 采购单金额", "Invoice Prepare(Y/N) 发票准备状态 ",
                            "invoice amount 发票金额", "预估竣工日期[CW]", "固定资产竣工单号", "竣工状态（ongoing/done", "竣工金额", "Booking status -- Fin.(Y/N)",

                            "Cost"
                        ]
          count = 0
          cs.each do |capex|

            capex.budgets.each_with_index do |budget, index|
              #Budget 整行
              row = [
                  count+=1,
                  index==0 ? capex.project : '',
                  budget.code,
                  BudgetType.display(budget.type),
                  budget.desc
              ]

              tmp_row = [] #Array.new(9, '')
              budget.budget_items.each do |budget_item|
                tmp_row+=[budget_item.qty, budget_item.unit_price, budget_item.total_price]
              end
              raise '预算子项不应该超过3个，请检查' if tmp_row.size>9
              tmp_row+=Array.new(9-tmp_row.size, '')
              row+=tmp_row

              row+=[
                  '',
                  budget.pam_lists.pluck(:cost).reduce(0) { |sum, i| sum+i.to_f },
                  budget.pam_lists.pluck(:remained).reduce(0) { |sum, i| sum+i.to_f },
                  '', '',
                  budget.pam_lists.pluck(:in_process).reduce(0) { |sum, i| sum+i.to_f },
                  budget.pam_lists.pluck(:approved).reduce(0) { |sum, i| sum+i.to_f },
                  budget.latest_budget_item.blank? ? '' : budget.latest_budget_item.total_price-budget.pam_lists.pluck(:approved).reduce(0) { |sum, i| sum+i.to_f },
                  '', '', '',
                  budget.pam_items.pluck(:total_cost).reduce(0) { |sum, i| sum+i.to_f },
                  '', '', '', '', '', '', '',
                  budget.pam_items.pluck(:po_cost).reduce(0) { |sum, i| sum+i.to_f },
                  '',
                  budget.pam_items.pluck(:invoice_amount).reduce(0) { |sum, i| sum+i.to_f },
                  '', '', '',
                  budget.pam_items.pluck(:completed_amount).reduce(0) { |sum, i| sum+i.to_f },
                  '',
                  budget.pam_items.pluck(:final_cost).reduce(0) { |sum, i| sum+i.to_f },
              ]
              #add budget
              sheet.add_row row

              #add pam
              budget.pam_lists.each do |pam_list|
                budget_row=[count+=1]
                budget_row+=Array.new(13, '')
                pam_list_row=[
                    pam_list.nr,
                    pam_list.cost,
                    pam_list.remained,
                    pam_list.is_final_approved ? 'Y' : 'N',
                    pam_list.is_final_approved ? 'Final Approved' : '',
                    pam_list.in_process,
                    pam_list.approved,
                    pam_list.budget_not_applied,
                ]
                pam_list.pam_items.each_with_index do |pam_item, j|
                  row=[]
                  j==0 ? (row=budget_row+pam_list_row) : (row=[count+=1]+Array.new(21, ''))
                  row+=[
                      pam_item.pa_no,
                      pam_item.description,
                      pam_item.qty,
                      pam_item.total_cost,
                      pam_item.applicant,
                      pam_item.applicant_date,
                      pam_item.supplier,
                      pam_item.sap_no,
                      pam_item.arrive_date,
                      pam_item.final_release ? 'Y' : 'N',
                      pam_item.po_no,
                      pam_item.po_cost,
                      pam_item.invoice_prepared ? 'Y' : 'N',
                      pam_item.invoice_amount,
                      pam_item.completed_date,
                      pam_item.completed_id,
                      pam_item.completed_status,
                      pam_item.completed_amount,
                      pam_item.booking_status ? 'Y' : 'N',
                      pam_item.final_cost
                  ]

                  #add pam item
                  sheet.add_row row
                end
              end
            end

          end
        end
      end
    end

    # budget.capex.bu.name,
    #     budget.capex.project,
    #     budget.code,
    # BudgetType.display(budget.type),
    #     budget.desc,
    #     (budget.budget_items[0].blank? ? '' : budget.budget_items[0].total_price),
    #     (budget.budget_items[1].blank? ? '' : budget.budget_items[1].total_price),
    #
    #     (budget.budget_items[2].blank? ? '' : budget.budget_items[2].total_price),
    #     budget.sum_pams_column(:approved),
    #     budget.sum_pams_column(:in_process),
    #     budget.sum_pams_column(:budget_not_applied),
    #
    #     budget.sum_pam_items_cloumn(:total_cost),
    #     budget.sum_pam_items_cloumn(:po_cost),
    #     budget.sum_pam_items_cloumn(:completed_amount),
    #     budget.sum_pam_items_cloumn(:final_cost)

    wb.add_worksheet(:name => "all code") do |sheet|
      sheet.add_row [
                        'BU', 'Project', 'Budget Code', 'Type', 'Item', 'Budget', 'FC1', 'FC2', 'PAM Final approved', 'PAM approval in process', 'PAM not start to approve', 'PA Cost',
                        'PO Cost', 'Fix assets complated cost', 'Booking Cost'
                    ]

      Budget.joins(:capex).order("capexes.bu_code, budgets.code").each do |budget|
        sheet.add_row [
                          budget.capex.bu.name,
                          budget.capex.project,
                          budget.code,
                          BudgetType.display(budget.type),
                          budget.desc,
                          (budget.budget_items[0].blank? ? '' : budget.budget_items[0].total_price),
                          (budget.budget_items[1].blank? ? '' : budget.budget_items[1].total_price),

                          (budget.budget_items[2].blank? ? '' : budget.budget_items[2].total_price),
                          budget.sum_pams_column(:approved),
                          budget.sum_pams_column(:in_process),
                          budget.sum_pams_column(:budget_not_applied),

                          budget.sum_pam_items_cloumn(:total_cost),
                          budget.sum_pam_items_cloumn(:po_cost),
                          budget.sum_pam_items_cloumn(:completed_amount),
                          budget.sum_pam_items_cloumn(:final_cost)
                      ]
      end
    end

    wb.add_worksheet(:name => "detail by project") do |sheet|
      sheet.add_row [
                        'BU', 'Project', 'Budget', 'FC1', 'FC2', 'Budget in process', 'PAM Final approved', 'PAM not applied', 'Approved budget spent',
                        'Approved budget not spent', 'Fix assets complated', 'Booking in Fin', 'Budget spent/Budget', 'Assets complated/Budget spent',
                        'Booked/Budget', 'Approved budget spent', 'Approved budget not spent', 'Fix assets complated', 'Booked in Fin'
                    ]

      Capex.all.order(:bu_code, :project).each do |capex|
        sheet.add_row [
                          capex.bu.name,
                          capex.project,

                          capex.sum_budget(0),
                          capex.sum_budget(1),

                          capex.sum_budget(2),
                          capex.sum_pams_column(:in_process),
                          capex.sum_pams_column(:approved),
                          capex.sum_pams_column(:budget_not_applied),

                          capex.sum_pam_items_cloumn(:total_cost),
                          capex.sum_pams_column(:approved) - capex.sum_pam_items_cloumn(:total_cost),
                          capex.sum_pam_items_cloumn(:completed_amount),
                          capex.sum_pam_items_cloumn(:final_cost),

                          capex.calc_percent(capex.sum_pam_items_cloumn(:total_cost), capex.sum_budget(0)),
                          capex.calc_percent(capex.sum_pam_items_cloumn(:completed_amount), capex.sum_pam_items_cloumn(:total_cost)),
                          capex.calc_percent(capex.sum_pam_items_cloumn(:final_cost), capex.sum_budget(0)),

                          capex.calc_percent(capex.sum_pam_items_cloumn(:total_cost), capex.sum_budget(1)),
                          capex.calc_percent(capex.sum_pam_items_cloumn(:final_cost), capex.sum_budget(1)),
                          capex.calc_percent(capex.sum_pam_items_cloumn(:total_cost), capex.sum_budget(2)),
                          capex.calc_percent(capex.sum_pam_items_cloumn(:final_cost), capex.sum_budget(2))
                      ]
      end
    end

    wb.add_worksheet(:name => "over view") do |sheet|

      sheet.add_row (['Version']+BuManger.all.pluck(:nr)+['Sum'])

      CapexService.generate_report_data(2017).each do |capex|
        row=[]
        capex.keys.each do |key|
          row<<capex[key]
        end
        sheet.add_row row
      end
    end

    p.to_stream.read
  end
end
