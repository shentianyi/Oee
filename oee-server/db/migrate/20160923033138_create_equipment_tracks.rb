class CreateEquipmentTracks < ActiveRecord::Migration[5.0]
  def change
    create_table :equipment_tracks do |t|
      t.string :level
      t.string :name
      t.string :nr
      t.integer :type
      t.string :asset_nr
      t.string :description
      t.string :product_id
      t.string :equipment_serial_id
      t.string :supplier
      t.string :status
      t.string :profit_center
      t.string :department
      t.string :project
      t.string :location
      t.string :area
      t.string :position
      t.datetime :procurment_date
      t.float :release_cycle, default: 0.0
      t.datetime :next_release
      t.string :release_notice
      t.string :responsibilityer
      t.string :remark
      t.boolean :is_top, default: true

      t.timestamps
    end
  end
end
