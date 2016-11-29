class AssetMoveEnum
  MOVE=0
  NORMAL=1

  def self.display(type)
    case type
      when MOVE
        '已转出'
      when NORMAL
        '正常'
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