class ImportTemplate
  HOLIDAY_EXCEL_TEMPLATE='holiday_template.xlsx'
  MACHINE_EXCEL_TEMPLATE='machine_template.xlsx'
  CRAFT_EXCEL_TEMPLATE='craft_template.xlsx'
  WORK_TIME_EXCEL_TEMPLATE='work_time_template.xlsx'
  DOWNTIME_TYPE_EXCEL_TEMPLATE='downtime_type_template.xlsx'
  DOWNTIME_CODE_EXCEL_TEMPLATE='downtime_code_template.xlsx'
  DOWNTIME_RECORD_EXCEL_TEMPLATE='downtime_record_template.xlsx'
  EQUIPMENT_TRACK_EXCEL_TEMPLATE='equipment_track_template.xlsx'
  EQUIPMENT_DEPRECIATION_EXCEL_TEMPLATE='equipment_depreciation_template.xlsx'
  EQUIPMENT_RELEASE_EXCEL_TEMPLATE='equipment_release_template.xlsx'
  FIX_ASSET_TRACK_EXCEL_TEMPLATE='fix_asset_track_template.xlsx'
  ASSET_BALANCE_ITEM_EXCEL_TEMPLATE='asset_balance_item_template.xlsx'
  INVENTORY_ITEM_EXCEL_TEMPLATE='inventory_item_template.xlsx'
  PURCHASE_PAM_EXCEL_TEMPLATE='purchase_pam_template.xlsx'
  TS_PAM_EXCEL_TEMPLATE='ts_pam_template.xlsx'
  FINANCE_PAM_EXCEL_TEMPLATE='finance_pam_template.xlsx'

  def self.method_missing(method_name, *args, &block)
    if method_name.to_s.include?('_template')
      return Base64.urlsafe_encode64(File.join($template_file_path, self.const_get(method_name.upcase)))
    else
      super
    end
  end
end