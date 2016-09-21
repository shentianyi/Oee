class AddMonthlyCloumnToDowntimeRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :downtime_records, :monthly, :integer
  end
end
