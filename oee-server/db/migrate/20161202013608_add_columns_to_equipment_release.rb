class AddColumnsToEquipmentRelease < ActiveRecord::Migration[5.0]
  def change
    add_column :equipment_releases, :reason, :string
    add_column :equipment_releases, :report, :string
    add_column :equipment_releases, :user_id, :string
  end
end
