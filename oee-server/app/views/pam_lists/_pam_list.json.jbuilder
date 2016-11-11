json.extract! pam_list, :id, :nr, :cost, :remained, :is_final_approved, :in_process, :approved, :budget_not_applied, :budget_id, :created_at, :updated_at
json.url pam_list_url(pam_list, format: :json)