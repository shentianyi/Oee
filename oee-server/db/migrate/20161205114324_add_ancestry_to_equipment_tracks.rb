class AddAncestryToEquipmentTracks < ActiveRecord::Migration[5.0]
  def change
    add_column :equipment_tracks, :ancestry, :string
    add_index :equipment_tracks, :ancestry


    add_column :equipment_tracks, :equip_create_way, :integer
  end
end
