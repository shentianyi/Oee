class CreateEquipmentReleases < ActiveRecord::Migration[5.0]
  def change
    create_table :equipment_releases do |t|
      t.references :equipment_track, foreign_key: true
      t.integer :release_index
      t.datetime :release_time

      t.timestamps
    end
  end
end
