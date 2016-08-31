json.extract! downtime_code, :id, :nr, :downtime_type_id, :description, :created_at, :updated_at
json.url downtime_code_url(downtime_code, format: :json)