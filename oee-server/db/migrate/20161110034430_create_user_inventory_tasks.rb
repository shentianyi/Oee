class CreateUserInventoryTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :user_inventory_tasks do |t|
      t.references :user, foreign_key: true
      t.references :inventory_list, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.integer :type
      t.integer :target_qty
      t.integer :real_qty

      t.timestamps
    end
  end
end
