class CreateBudgets < ActiveRecord::Migration[5.0]
  def change
    create_table :budgets do |t|
      t.string :code
      t.integer :type
      t.string :desc
      t.references :capex, foreign_key: true

      t.timestamps
    end
  end
end
