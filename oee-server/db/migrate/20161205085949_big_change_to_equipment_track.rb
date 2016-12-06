class BigChangeToEquipmentTrack < ActiveRecord::Migration[5.0]
  def change
    rename_column :equipment_tracks, :procurment_date, :cap_date
    rename_column :equipment_tracks, :area, :ts_area_id
    rename_column :equipment_tracks, :responsibilityer, :asset_bu_id

    add_column :equipment_tracks, :asset_class, :string
    add_column :equipment_tracks, :inventory_user_id, :integer
    add_column :equipment_tracks, :keeper, :string
    add_column :equipment_tracks, :nameplate_track, :string
    add_column :equipment_tracks, :ts_type, :string
    add_column :equipment_tracks, :ts_equipment_type, :string

    add_column :equipment_tracks, :inventory_result, :string
    add_column :equipment_tracks, :process_params, :string
    add_column :equipment_tracks, :maintain_plan, :string
    add_column :equipment_tracks, :machine_down, :string
    add_column :equipment_tracks, :big_maintain_plan, :string

    add_column :equipment_tracks, :instruction, :string
    add_column :equipment_tracks, :replacement_list, :string
  end
end
