class UserGroupEnum
  FIXASSET = 100
  OEE = 200

  def self.display(type)
    case type
      when FIXASSET
        '固定资产系统'
      when OEE
        'OEE系统'
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