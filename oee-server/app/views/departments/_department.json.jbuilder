json.extract! department, :id, :nr, :name, :description, :created_at, :updated_at
json.url department_url(department, format: :json)