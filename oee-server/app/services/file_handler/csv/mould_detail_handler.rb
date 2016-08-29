require 'csv'
module FileHandler
  module Csv
    class MouldDetailHandler<Base
      IMPORT_HEADERS=['模具号', '模具型号', '模具供应商', '状态', '库位号', '端子莱尼号', '端子供应商', '防水塞','使用范围','电线型号','电线截面','原始参数CH', '原始参数CW',
                      '实测参数CH','实测参数CW','实测参数ICH','实测参数ICW','步骤DCH','步骤ICH','下次批准日期','芯线上刀','芯线下刀','绝缘上刀','绝缘下刀','上冲头','切断刀',
                      '切断刀座', '送料爪','后凹槽','前凹槽','杯油','购买日期','放行报告','固定资产号','是否闲置','闲置日期','备注']
      INVALID_CSV_HEADERS=IMPORT_HEADERS<<'Error MSG'

      def self.import(file)
        msg = Message.new
        begin
          validate_msg = validate_import(file)
          if validate_msg.result
            MouldDetail.transaction do
              CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
                #row.strip

                params = {}
                IMPORT_HEADERS.each { |header|
                  unless (row[header].nil? || header_to_attr(header).nil?)
                    params[header_to_attr(header)] = row[header]
                  end
                }
                puts params
                MouldDetail.create(params)
              end
            end
            msg.result = true
            msg.content = '模具详细 上传成功'
          else
            msg.result = false
            msg.content = validate_msg.content
          end
        rescue => e
          puts e.backtrace
          msg.content = e.message
        end
        return msg
      end

      def self.validate_import(file)
        tmp_file=full_tmp_path(file.file_name)
        msg=Message.new(result: true)
        CSV.open(tmp_file, 'wb', write_headers: true,
                 headers: INVALID_CSV_HEADERS, col_sep: file.col_sep, encoding: file.encoding) do |csv|
          CSV.foreach(file.file_path, headers: file.headers, col_sep: file.col_sep, encoding: file.encoding) do |row|
            mmsg = validate_row(row)
            if mmsg.result
              csv<<row.fields
            else
              if msg.result
                msg.result=false
                msg.content = "请下载错误文件<a href='/files/#{Base64.urlsafe_encode64(tmp_file)}'>#{::File.basename(tmp_file)}</a>"
              end
              csv<<(row.fields<<mmsg.content)
            end
          end
        end
        return msg
      end

      def self.validate_row(row)
        msg=Message.new(contents: [])
        if MouldDetail.find_by_mould_id(row['模具号'].to_i)
          msg.contents<<"该模具已存在！"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        return msg
      end

      def self.header_to_attr header
        case header
          when '模具号'
            :mould_id
          when '模具型号'
            :mould_type
          when '模具供应商'
            :mould_supplier
          when '状态'
            :mould_state
          when '库位号'
            :position
          when '端子莱尼号'
            :terminal_leoni_no
          when '端子供应商'
            :terminal_supplier
          when '防水塞'
            :stopwater
          when '使用范围'
            :use_range
          when '电线型号'
            :wire_type
          when '电线截面'
            :wire_cross
          when '原始参数CH'
            :original_param_ch
          when '原始参数CW'
            :original_param_cw
          when '实测参数CH'
            :actual_param_ch
          when '实测参数CW'
            :actual_param_cw
          when '实测参数ICH'
            :actual_param_ich
          when '实测参数ICW'
            :actual_param_icw
          when '步骤DCH'
            :step_dch_id
          when '步骤ICH'
            :step_ich_id
          when '下次批准日期'
            :next_time
          when '芯线上刀'
            :c_up_knife
          when '芯线下刀'
            :c_down_knife
          when '绝缘上刀'
            :i_up_knife
          when '绝缘下刀'
            :i_down_knife
          when '上冲头'
            :upper_punch
          when '切断刀'
            :coc
          when '切断刀座'
            :coh
          when '送料爪'
            :feeding_claw
          when '后凹槽'
            :after_groove
          when '前凹槽'
            :before_groove
          when '杯油'
            :oil_cup
          when '购买日期'
            :buy_time
          when '放行报告'
            :release_report
          when '固定资产号'
            :fixed_asset_id
          when '是否闲置'
            :is_idle
          when '闲置日期'
            :idle_time
          when '备注'
            :note
          else
        end
      end

      def self.get_encoding(user_agent)
        os=System::Base.os_by_user_agent(user_agent)
        case os
          when 'windows'
            return 'GB18030:UTF-8'
          when 'linux', 'macintosh'
            return 'UTF-8:UTF-8'
          else
            return 'UTF-8:UTF-8'
        end
      end
    end
  end
end
