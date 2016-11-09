json.extract! inventory_list, :id, :name, :inventory_date, :asset_balance_list_id, :created_at, :updated_at
json.url inventory_list_url(inventory_list, format: :json)