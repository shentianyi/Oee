class CreateCrafts < ActiveRecord::Migration[5.0]
  def change
    create_table :crafts do |t|
      t.string :nr
      t.string :description

      t.timestamps
    end
  end
end
