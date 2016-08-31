json.extract! downtime_type, :id, :nr, :name, :description, :created_at, :updated_at
json.url downtime_type_url(downtime_type, format: :json)