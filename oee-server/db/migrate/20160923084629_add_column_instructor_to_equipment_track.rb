class AddColumnInstructorToEquipmentTrack < ActiveRecord::Migration[5.0]
  def change
    add_column :equipment_tracks, :operate_instructor, :string
    add_column :equipment_tracks, :maintain_instructor, :string
  end
end
