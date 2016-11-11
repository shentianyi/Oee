class CreatePamLists < ActiveRecord::Migration[5.0]
  def change
    create_table :pam_lists do |t|
      t.string :nr
      t.float :cost
      t.float :remained
      t.boolean :is_final_approved
      t.string :in_process
      t.string :approved
      t.string :budget_not_applied
      t.references :budget, foreign_key: true

      t.timestamps
    end
  end
end
