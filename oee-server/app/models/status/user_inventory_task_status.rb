class UserInventoryTaskStatus<BaseStatus
  OPEN=100
  PROCESSING=200
  CLOSE=300
  ERROR=400

  def self.display(status)
    case status
      when OPEN
        '新建任务'
      when PROCESSING
        '处理中'
      when CLOSE
        '结束'
      when ERROR
        '出错'
    end
  end
end