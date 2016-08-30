json.extract! machine, :id, :nr, :machine_type_id, :oee_nr, :department_id, :status, :remark, :created_at, :updated_at
json.url machine_url(machine, format: :json)