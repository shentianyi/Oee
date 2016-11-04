class CreateAssetBalanceItems < ActiveRecord::Migration[5.0]
  def change
    create_table :asset_balance_items do |t|
      t.references :fix_asset_track, foreign_key: true
      t.datetime :cap_date
      t.string :profit_center
      t.string :asset_description
      t.float :acquis_val
      t.float :accum_dep
      t.float :book_val
      t.string :asset_class
      t.string :inventory_nr
      t.string :ts_equipment_nr
      t.string :ts_project
      t.string :ts_inventory_user
      t.string :ts_keeper
      t.string :ts_position
      t.string :ts_nameplate_track
      t.string :ts_type
      t.string :ts_equipment_type
      t.string :ts_area
      t.string :ts_supplier
      t.string :status
      t.string :remark
      t.string :ts_inventory_result

      t.timestamps
    end
  end
end
