class CreateDowntimeTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :downtime_types do |t|
      t.string :nr
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
