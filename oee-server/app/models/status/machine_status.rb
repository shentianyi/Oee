class MachineStatus<BaseStatus
  OPEN = 100
  CLOSED = 200
  OTHER = 300

  def self.display status
    case status
      when OPEN
        '打开的'
      when CLOSED
        '关闭的'
      else
        '其它'
    end
  end
end