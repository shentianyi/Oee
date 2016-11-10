json.extract! budget, :id, :code, :type, :desc, :capex_id, :created_at, :updated_at
json.url budget_url(budget, format: :json)