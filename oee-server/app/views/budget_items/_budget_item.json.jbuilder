json.extract! budget_item, :id, :qty, :unit_price, :total_price, :budget_id, :created_at, :updated_at
json.url budget_item_url(budget_item, format: :json)