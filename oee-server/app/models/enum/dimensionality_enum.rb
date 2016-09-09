class DimensionalityEnum
  MACHINE = 100
  TIME = 200

  def self.display(type)
    case type
      when MACHINE
        '机器维度'
      when TIME
        '时间维度'
    end
  end

  def self.menu
    data = []
    self.constants.each do |c|
      v = self.const_get(c.to_s)
      data << [self.display(v),v]
    end
    data
  end

end