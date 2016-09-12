class Holiday < ApplicationRecord
  self.inheritance_column = :_type_disabled

  validates_presence_of :holiday, :message => "节假日不可为空!"
  validates_uniqueness_of :holiday, :message => "节假日已登记!"


  def self.calc_except_holiday start_date, end_date
    holidays = Holiday.pluck(:holiday).map { |h| h.to_date.strftime("%Y-%m-%d").to_s }

    if start_date==end_date
      if holidays.include?(start_date.strftime('%Y-%m-%d'))
        return 24.0
      else
        return 0.0
      end
    end

    total_hours = 0
    (start_date...end_date).each do |d|
      unless holidays.include?(d.strftime('%Y-%m-%d'))
        total_hours += 24.0
      end
    end

    total_hours
  end
end
