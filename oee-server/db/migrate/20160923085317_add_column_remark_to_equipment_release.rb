class AddColumnRemarkToEquipmentRelease < ActiveRecord::Migration[5.0]
  def change
    add_column :equipment_releases, :remark, :string
  end
end
