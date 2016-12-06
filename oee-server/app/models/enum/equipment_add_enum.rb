class EquipmentAddEnum
  CREATE_EQUIPMENT = 100
  ADD_EQUIPMENT = 200
  ONE_ASSET_SOME_EQUIPMENTS = 300

  @@enum_name={
      CREATE_EQUIPMENT: '新建',
      ADD_EQUIPMENT: '追加',
      ONE_ASSET_SOME_EQUIPMENTS: '一资产多设备'
  }

  def self.get_enum_names
    @@enum_name.values
  end

  def self.display(type)
    case type
      when CREATE_EQUIPMENT
        '新建'
      when ADD_EQUIPMENT
        '追加'
      when ONE_ASSET_SOME_EQUIPMENTS
        '一资产多设备'
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

  def self.decode name
    case name
      when '新建'
        CREATE_EQUIPMENT
      when '追加'
        ADD_EQUIPMENT
      when '一资产多设备'
        CLIENT_ASSET
      else
        ONE_ASSET_SOME_EQUIPMENTS
    end
  end

end