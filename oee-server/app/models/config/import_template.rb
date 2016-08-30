class ImportTemplate
  HOLIDAY_EXCEL_TEMPLATE='holiday_template.xlsx'
  MACHINE_EXCEL_TEMPLATE='machine_template.xlsx'
  CRAFT_EXCEL_TEMPLATE='craft_template.xlsx'
  WORK_TIME_EXCEL_TEMPLATE='work_time_template.xlsx'

  def self.method_missing(method_name, *args, &block)
    if method_name.to_s.include?('_template')
      return Base64.urlsafe_encode64(File.join($template_file_path, self.const_get(method_name.upcase)))
    else
      super
    end
  end
end