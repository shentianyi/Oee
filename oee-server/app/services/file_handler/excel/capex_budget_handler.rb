module FileHandler
  module Excel
    class CapexBudgetHandler<Base
      CAPEX_HEADERS=[
          :bu, :project, :budget_code, :type, :description, :budget_qty, :budget_unit_price, :budget_exchange_rate,
          :fc1_qty, :fc1_unit_price, :fc1_exchange_rate, :fc2_qty, :fc2_unit_price, :fc2_exchange_rate
      ]

      CAPEX_ZH_HEADERS=[
          'BU', 'Project', 'Budget Code', 'Type', 'Description',
          'Budget Qty', 'Budget Unit Price', 'Budget Exchange Rate',
          'FC1 Qty', 'FC1 Unit Price', 'FC1 Exchange Rate',
          'FC2 Qty', 'FC2 Unit Price', 'FC2 Exchange Rate'
      ]

      def self.import(file)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg = validate_import(file)
        if validate_msg.result
          #validate file
          begin
            count = 0
            Capex.transaction do
              data = {}
              2.upto(book.last_row) do |line|
                row = {}
                CAPEX_HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k] = row[k].sub(/\.0/, '') if k==:type
                end

                bu = BuManger.find_by_nr(row[:bu])
                capex=Capex.where(bu_code: bu.id, project: row[:project]).first
                if data[row[:bu] + row[:project]].blank?
                  data[row[:bu] + row[:project]] = {}
                  data[row[:bu] + row[:project]][row[:budget_code]] = {
                      bu: bu.id,
                      project: row[:project],
                      capex: capex,
                      type: row[:type],
                      description: row[:description],
                      budget_items: {
                        fc0: {
                            qty: row[:budget_qty],
                            unit: row[:budget_unit_price],
                            rate: row[:budget_exchange_rate]
                        },
                        fc1: {
                            qty: row[:fc1_qty],
                            unit: row[:fc1_unit_price],
                            rate: row[:fc1_exchange_rate]
                        },
                        fc2: {
                            qty: row[:fc2_qty],
                            unit: row[:fc2_unit_price],
                            rate: row[:fc2_exchange_rate]
                        }
                      }
                  }
                else
                  data[row[:bu] + row[:project]][row[:budget_code]] = {
                      bu: bu.id,
                      project: row[:project],
                      capex: capex,
                      type: row[:type],
                      description: row[:description],
                      budget_items: {
                          fc0: {
                              qty: row[:budget_qty],
                              unit: row[:budget_unit_price],
                              rate: row[:budget_exchange_rate]
                          },
                          fc1: {
                              qty: row[:fc1_qty],
                              unit: row[:fc1_unit_price],
                              rate: row[:fc1_exchange_rate]
                          },
                          fc2: {
                              qty: row[:fc2_qty],
                              unit: row[:fc2_unit_price],
                              rate: row[:fc2_exchange_rate]
                          }
                      }
                  }
                end
              end


              data.keys.each do |c|
                capex=nil
                data[c].keys.each do |b|
                  if data[c][b][:capex].blank? && capex.blank?
                    capex=Capex.new({bu_code: data[c][b][:bu], project: data[c][b][:project]})
                  else
                    capex = data[c][b][:capex] if capex.blank?
                  end

                  count += 1
                  budget = Budget.new({code: b, type: data[c][b][:type], desc: data[c][b][:description]})
                  data[c][b][:budget_items].keys.each do |i|
                    item = data[c][b][:budget_items][i]
                    budget.budget_items<< BudgetItem.new({qty: item[:qty], unit_price: item[:unit], total_price: item[:qty].to_f*item[:unit].to_f, exchange_rate: item[:rate], total_euro: item[:qty].to_f*item[:unit].to_f*item[:rate].to_f})
                  end
                  capex.budgets<<budget
                end

                capex.save
              end

            end
            msg.result = true
            msg.content = "导入 CAPEX 信息成功, #{count}条 Budget 记录成功改变！"
          rescue => e
            puts e.backtrace
            msg.result = false
            msg.content = e.message
          end
        else
          msg.result = false
          msg.content = validate_msg.content
        end
        msg
      end

      def self.validate_import file
        tmp_file=full_tmp_path(file.original_name)
        msg = Message.new(result: true)
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
          sheet.add_row CAPEX_ZH_HEADERS+['Error Msg']
          #validate file
          2.upto(book.last_row) do |line|
            row = {}
            CAPEX_HEADERS.each_with_index do |k, i|
              row[k] = book.cell(line, i+1).to_s.strip
              row[k] = row[k].sub(/\.0/, '') if k==:type
            end

            mssg = validate_row(row, line)
            if mssg.result
              sheet.add_row row.values
            else
              if msg.result
                msg.result = false
                msg.content = "下载错误文件<a href='/files/#{Base64.urlsafe_encode64(tmp_file)}'>#{::File.basename(tmp_file)}</a>"
              end
              sheet.add_row row.values<<mssg.content
            end
          end
        end
        p.use_shared_strings = true
        p.serialize(tmp_file)
        msg
      end

      def self.validate_row(row, line)
        msg = Message.new(contents: [])

        if row[:bu].blank?
          msg.contents<<"BU 不可为空"
        else
          if BuManger.find_by_nr(row[:bu]).blank?
            msg.contents<<"BU :#{row[:bu]} 不存在"
          end
        end

        if row[:budget_code].blank?
          msg.contents<<"Budget Code 不可为空"
        else
          if Budget.find_by_code(row[:budget_code])
            msg.contents<<"Budget Code :#{row[:budget_code]} 已存在"
          end
        end

        if row[:project].blank?
          msg.contents<<"Project 不可为空"
        end

        if row[:type].blank?
          msg.contents<<"Type 不可为空"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end

    end
  end
end