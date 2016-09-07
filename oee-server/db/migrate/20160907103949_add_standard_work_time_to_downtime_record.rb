class AddStandardWorkTimeToDowntimeRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :downtime_records, :standard_work_time, :float, default: 0.0
  end
end
