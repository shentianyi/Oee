class EquipmentStatusGroupEnum
  NORMAL = 100
  SCRAP = 200

  def self.display(type)
    case type
      when NORMAL
        '账上设备'
      when SCRAP
        '非账上设备'
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