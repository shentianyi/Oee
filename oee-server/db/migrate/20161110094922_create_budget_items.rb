class CreateBudgetItems < ActiveRecord::Migration[5.0]
  def change
    create_table :budget_items do |t|
      t.integer :qty
      t.float :unit_price
      t.float :total_price
      t.references :budget, foreign_key: true

      t.timestamps
    end
  end
end
