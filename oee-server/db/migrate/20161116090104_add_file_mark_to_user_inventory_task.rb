class AddFileMarkToUserInventoryTask < ActiveRecord::Migration[5.0]
  def change
    add_column :user_inventory_tasks, :data_file_id, :integer
    add_index :user_inventory_tasks, :data_file_id

    add_column :user_inventory_tasks, :error_file_id, :integer
    add_index :user_inventory_tasks, :error_file_id

    add_column :user_inventory_tasks, :status, :integer, default: 100
    add_index :user_inventory_tasks, :status
  end
end
