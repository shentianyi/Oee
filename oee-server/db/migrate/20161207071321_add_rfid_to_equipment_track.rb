class AddRfidToEquipmentTrack < ActiveRecord::Migration[5.0]
  def change
    add_column :inventory_items, :rfid_nr, :string

    add_column :equipment_tracks, :rfid_nr, :string
  end
end
