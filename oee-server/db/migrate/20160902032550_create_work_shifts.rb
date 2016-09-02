class CreateWorkShifts < ActiveRecord::Migration[5.0]
  def change
    create_table :work_shifts do |t|
      t.string :nr
      t.string :name
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
