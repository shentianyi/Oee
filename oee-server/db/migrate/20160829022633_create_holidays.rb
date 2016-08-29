class CreateHolidays < ActiveRecord::Migration[5.0]
  def change
    create_table :holidays do |t|
      t.date :holiday
      t.integer :type, default: 100
      t.string :remark

      t.timestamps
    end
  end
end
