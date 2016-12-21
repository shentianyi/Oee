module FileHandler
  module Excel
    class PamItemHandler<Base
      PURCHASE_HEADERS=[
          :sap_no, :po_no, :po_cost, :invoice_prepared, :invoice_amount
      ]

      TS_HEADERS=[
          :pa_no, :completed_date, :completed_id, :completed_status, :completed_amount
      ]

      TS_ZH_HEADERS=[
          '请购单号', '预计竣工日期', '固定资产竣工单号', '竣工状态', '竣工金额'
      ]

      FINANCE_HEADERS=[
          :sap_no, :booking_status, :final_cost
      ]

      FINANCE_ZH_HEADERS=[
          '采购订单号', 'Booking Status(Y/N)', 'Fin Cost'
      ]

      def self.finance_import(file)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg = validate_finance_import(file)
        if validate_msg.result
          #validate file
          begin
            count = 0
            PamItem.transaction do
              2.upto(book.last_row) do |line|
                row = {}
                FINANCE_HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k] = row[k].sub(/\.0/, '') if k==:sap_no
                end
                row[:booking_status]=row[:booking_status]=='Y' ? true : false

                count += 1

                items = PamItem.where(sap_no: row[:sap_no])
                items.each do |i|
                  i.update_attributes({
                                          booking_status: row[:booking_status],
                                          final_cost: row[:final_cost]
                                      })
                end
              end
            end
            msg.result = true
            msg.content = "导入 财务 CAPEX 信息成功, #{count}条记录成功改变！"
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

      def self.validate_finance_import file
        tmp_file=full_tmp_path(file.original_name)
        msg = Message.new(result: true)
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
          sheet.add_row FINANCE_ZH_HEADERS+['Error Msg']
          #validate file
          2.upto(book.last_row) do |line|
            row = {}
            FINANCE_HEADERS.each_with_index do |k, i|
              row[k] = book.cell(line, i+1).to_s.strip
              row[k] = row[k].sub(/\.0/, '') if k==:sap_no
            end

            mssg = validate_finance_row(row, line)
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

      def self.validate_finance_row(row, line)
        msg = Message.new(contents: [])

        if row[:sap_no].blank?
          msg.contents<<"SAP NO 不可为空"
        else
          if (pi=PamItem.find_by_sap_no(row[:sap_no])).blank?
            msg.contents<<"SAP NO :#{row[:sap_no]} 不存在"
          end
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end

#---------------------------------------------------------------------------------------------------------------------------------------------------------

      def self.ts_import(file)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg = validate_ts_import(file)
        if validate_msg.result
          #validate file
          begin
            count = 0
            PamItem.transaction do
              2.upto(book.last_row) do |line|
                row = {}
                TS_HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k] = row[k].sub(/\.0/, '') if k==:pa_no
                end

                count += 1

                # asset = FixAssetTrack.find_by_procurment_id(row[:pa_no])
                items = PamItem.where(pa_no: row[:pa_no])
                items.each do |i|
                  i.update_attributes({
                                          completed_date: row[:completed_date],
                                          completed_id: row[:completed_id],
                                          completed_status: row[:completed_status],
                                          completed_amount: row[:completed_amount]
                                      })
                  # i.update_attributes({
                  #                         completed_date: row[:completed_date],
                  #                         completed_id: asset.blank? ? row[:completed_id] : asset.completed_id,
                  #                         completed_status: asset.blank? ? row[:completed_status] : FixAssetStatus.display(asset.status),
                  #                         completed_amount: row[:completed_amount]
                  #                     })
                end
              end
            end
            msg.result = true
            msg.content = "导入 TS CAPEX 信息成功, #{count}条记录成功改变！"
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

      def self.validate_ts_import file
        tmp_file=full_tmp_path(file.original_name)
        msg = Message.new(result: true)
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
          sheet.add_row TS_ZH_HEADERS+['Error Msg']
          #validate file
          2.upto(book.last_row) do |line|
            row = {}
            TS_HEADERS.each_with_index do |k, i|
              row[k] = book.cell(line, i+1).to_s.strip
              row[k] = row[k].sub(/\.0/, '') if k==:pa_no
            end

            mssg = validate_ts_row(row, line)
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

      def self.validate_ts_row(row, line)
        msg = Message.new(contents: [])

        if row[:pa_no].blank?
          msg.contents<<"PA NO 不可为空"
        else
          if (pi=PamItem.find_by_pa_no(row[:pa_no])).blank?
            msg.contents<<"PA NO :#{row[:pa_no]} 不存在"
          end
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end

#---------------------------------------------------------------------------------------------------------------------------------------------------------

      def self.purchase_import(file)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg = validate_purchase_import(file)
        if validate_msg.result
          #validate file
          begin
            count = 0
            PamItem.transaction do
              2.upto(book.last_row) do |line|
                row = {}
                PURCHASE_HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k] = row[k].sub(/\.0/, '') if k==:sap_no
                end
                row[:invoice_prepared] = row[:invoice_prepared]=='Y' ? true : false

                count += 1

                items = PamItem.where(sap_no: row[:sap_no])
                items.each do |i|
                  i.update_attributes({
                                          po_no: row[:po_no],
                                          po_cost: row[:po_cost],
                                          invoice_prepared: row[:invoice_prepared],
                                          invoice_amount: row[:invoice_amount]
                                      })
                end
              end
            end
            msg.result = true
            msg.content = "导入 采购 CAPEX 信息成功, #{count}条记录成功改变！"
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

      def self.validate_purchase_import file
        tmp_file=full_tmp_path(file.original_name)
        msg = Message.new(result: true)
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
          sheet.add_row PURCHASE_HEADERS+['Error Msg']
          #validate file
          2.upto(book.last_row) do |line|
            row = {}
            PURCHASE_HEADERS.each_with_index do |k, i|
              row[k] = book.cell(line, i+1).to_s.strip
              row[k] = row[k].sub(/\.0/, '') if k==:sap_no
            end

            mssg = validate_purchase_row(row, line)
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

      def self.validate_purchase_row(row, line)
        msg = Message.new(contents: [])

        if row[:sap_no].blank?
          msg.contents<<"SAP NO 不可为空"
        else
          if (pi=PamItem.find_by_sap_no(row[:sap_no])).blank?
            msg.contents<<"SAP NO :#{row[:sap_no]} 不存在"
          end
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end

    end
  end
end