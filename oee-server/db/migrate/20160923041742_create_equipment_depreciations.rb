class CreateEquipmentDepreciations < ActiveRecord::Migration[5.0]
  def change
    create_table :equipment_depreciations do |t|
      t.datetime :depreciation_time
      t.float :original_val
      t.float :depreciation_val
      t.float :net_val
      t.references :equipment_track, foreign_key: true

      t.timestamps
    end
  end
end
