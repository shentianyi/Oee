class HolidayType < BaseType
  NATIONAL_HOLIDAY=100
  WEEKENDS=200

  @@type_name = {
      NATIONAL_HOLIDAY => '国家法定假日',
      WEEKENDS => '周末'
  }

  def self.get_type(type)
    self.const_get(type.upcase)
  end

  def self.get_type_name(type)
    @@type_name[type]
  end

  def self.display(type)
    case type
      when NATIONAL_HOLIDAY
        '国家法定假日'
      when WEEKENDS
        '周末'
    end
  end
end