class CreateUserAreaItems < ActiveRecord::Migration[5.0]
  def change
    create_table :user_area_items do |t|
      t.references :user, foreign_key: true
      t.references :area, foreign_key: true

      t.timestamps
    end
  end
end
