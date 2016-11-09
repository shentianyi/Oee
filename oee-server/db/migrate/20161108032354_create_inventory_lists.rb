class CreateInventoryLists < ActiveRecord::Migration[5.0]
  def change
    create_table :inventory_lists do |t|
      t.string :name
      t.datetime :inventory_date
      t.string :asset_balance_list_id

      t.timestamps
    end
  end
end
