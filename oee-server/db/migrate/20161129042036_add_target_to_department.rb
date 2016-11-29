class AddTargetToDepartment < ActiveRecord::Migration[5.0]
  def change
    add_column :departments, :target, :float, default: 0
  end
end
