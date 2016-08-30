class CreateWorkTimes < ActiveRecord::Migration[5.0]
  def change
    create_table :work_times do |t|
      t.references :machine_type, foreign_key: true
      t.references :craft, foreign_key: true
      t.integer :wire_length
      t.float :std_time

      t.timestamps
    end
  end
end
