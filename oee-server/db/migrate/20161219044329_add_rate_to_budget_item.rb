class AddRateToBudgetItem < ActiveRecord::Migration[5.0]
  def change
    add_column :budget_items, :exchange_rate, :float
    add_column :budget_items, :total_euro, :float
  end
end
