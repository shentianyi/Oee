class CreateCapexes < ActiveRecord::Migration[5.0]
  def change
    create_table :capexes do |t|
      t.string :project
      t.integer :bu_code
      t.string :desc

      t.timestamps
    end
  end
end
