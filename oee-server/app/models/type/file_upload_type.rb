class FileUploadType
  OVERALL=100
  RECOVERY=200

  def self.display(type)
    case type
      when OVERALL
        '全盘'
      when RECOVERY
        '纠错'
    end
  end

end