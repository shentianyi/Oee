class Attachment < ApplicationRecord

  mount_uploader :path, GuideUploader

  def self.url(id, http_host)
    if file=Attachment.find_by_id(id)
      http_host+file.path.url
    end
  end


end
