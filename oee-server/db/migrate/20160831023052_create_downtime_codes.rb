class CreateDowntimeCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :downtime_codes do |t|
      t.string :nr
      t.references :downtime_type, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
