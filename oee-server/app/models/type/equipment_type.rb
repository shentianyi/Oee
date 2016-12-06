class EquipmentType < BaseType
  EQUIPMENT=100
  FIX_ASSET=200
  CLIENT_ASSET=300

  @@type_name = {
      EQUIPMENT => '设备',
      FIX_ASSET => '固定资产',
      CLIENT_ASSET => '客户资产'
  }

  def self.get_type(type)
    self.const_get(type.upcase)
  end

  def self.get_type_name(type)
    @@type_name[type]
  end

  def self.get_type_names
    @@type_name.values
  end

  def self.display(type)
    case type
      when EQUIPMENT
        '设备'
      when FIX_ASSET
        '固定资产'
      when CLIENT_ASSET
        '客户资产'
    end
  end

  def self.decode type
    case type
      when '设备'
        EQUIPMENT
      when '固定资产'
        FIX_ASSET
      when '客户资产'
        CLIENT_ASSET
      else
        EQUIPMENT
    end
  end
end