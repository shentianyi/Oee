class CreateBuMangers < ActiveRecord::Migration[5.0]
  def change
    create_table :bu_mangers do |t|
      t.string :nr
      t.string :name
      t.string :finance_nr
      t.string :desc

      t.timestamps
    end
  end
end
