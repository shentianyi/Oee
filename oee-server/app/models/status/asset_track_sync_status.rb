class AssetTrackSyncStatus<BaseStatus
  INIT = 100
  ERROR = 200
  DONE = 300

  def self.display status
    case status
      when INIT
        'INIT'
      when ERROR
        'ERROR'
      when DONE
        'DONE'
      else
        'UNDONE'
    end
  end

  def self.menu
    data = []
    self.constants.each do |c|
      v = self.const_get(c)
      data << [self.display(v), v]
    end
    data
  end
end