class BudgetType < BaseType
  TOOLING=100
  TEST_FACILITY=200
  MACHINERY=300
  TEST_EQUIPMENT=400
  TOOLING_MACHINERY=500
  TOOLING_TEST_FACILITY_MACHINERY=600
  OTHERS=700

  # @@type_name = {
  #     NATIONAL_HOLIDAY => '国家法定假日',
  #     WEEKENDS => '周末'
  # }
  #
  # def self.get_type(type)
  #   self.const_get(type.upcase)
  # end
  #
  # def self.get_type_name(type)
  #   @@type_name[type]
  # end

  def self.display(type)
    case type
      when TOOLING
        'Tooling'
      when TEST_FACILITY
        'Test Facility'
      when MACHINERY
        'Machinery'
      when TEST_EQUIPMENT
        'Test Equipment'
      when TOOLING_MACHINERY
        'Tooling/Machinery'
      when TOOLING_TEST_FACILITY_MACHINERY
        'Tooling/Test Facility/Machinery'
      when OTHERS
        'Others'
    end
  end
end