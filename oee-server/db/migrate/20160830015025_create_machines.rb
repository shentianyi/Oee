class CreateMachines < ActiveRecord::Migration[5.0]
  def change
    create_table :machines do |t|
      t.string :nr
      t.references :machine_type, foreign_key: true
      t.string :oee_nr
      t.references :department, foreign_key: true
      t.integer :status, default: 100
      t.string :remark

      t.timestamps
    end
  end
end
