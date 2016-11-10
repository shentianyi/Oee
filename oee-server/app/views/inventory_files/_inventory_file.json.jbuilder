json.extract! inventory_file, :id, :name, :path, :size, :created_at, :updated_at
json.url inventory_file_url(inventory_file, format: :json)