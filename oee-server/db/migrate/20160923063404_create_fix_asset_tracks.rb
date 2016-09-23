class CreateFixAssetTracks < ActiveRecord::Migration[5.0]
  def change
    create_table :fix_asset_tracks do |t|
      t.datetime :info_receive_date
      t.string :apply_id
      t.string :description
      t.float :qty
      t.float :price
      t.string :proposer
      t.string :procurment_id
      t.datetime :procurment_date
      t.string :supplier
      t.string :project
      t.string :completed_id
      t.boolean :is_add_equipment, default: false
      t.string :equipment_nr
      t.boolean :is_add_fix_asset, default: false
      t.string :nr
      t.integer :status, default: 100
      t.string :remark
      t.integer :equipment_track_id

      t.timestamps
    end
  end
end
