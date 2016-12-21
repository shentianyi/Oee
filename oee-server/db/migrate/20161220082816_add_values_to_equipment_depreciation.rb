class AddValuesToEquipmentDepreciation < ActiveRecord::Migration[5.0]
  def change
    add_column :equipment_depreciations, :acquis_val, :float
    add_column :equipment_depreciations, :accum_val, :float
    add_column :equipment_depreciations, :book_val, :float
  end
end
