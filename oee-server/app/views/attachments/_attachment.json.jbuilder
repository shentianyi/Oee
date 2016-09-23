json.extract! attachment, :id, :name, :path, :size, :type, :attachable_id, :attachable_type, :created_at, :updated_at
json.url attachment_url(attachment, format: :json)