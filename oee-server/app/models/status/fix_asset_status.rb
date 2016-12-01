class FixAssetStatus<BaseStatus
  ON_GOING = 100
  DONE = 200
  UNDONE = 300
  DELE = 400

  def self.display status
    case status
      when ON_GOING
        'on going'
      when DONE
        'done'
      when UNDONE
        'undone'
      when DELE
        'delete'
      else
        '其它'
    end
  end

  def self.decode status
    case status
      when 'on going'
        ON_GOING
      when 'done'
        DONE
      when 'undone'
        UNDONE
      when 'delete'
        DELE
      else
        ON_GOING
    end
  end

  def self.default_menu
    data = []
    data << [self.display(FixAssetStatus::ON_GOING), FixAssetStatus::ON_GOING]
    data
  end

  def self.to_do_list
    [self::ON_GOING, self::UNDONE]
  end
end