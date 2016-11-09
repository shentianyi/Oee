class CreateAssetBalanceLists < ActiveRecord::Migration[5.0]
  def change
    create_table(:asset_balance_lists, :id=>false) do |t|
      t.string :id, :limit => 36, :primary=>true, :null=>false

      t.datetime :balance_date

      t.timestamps
    end

    add_index :asset_balance_lists,:id
    execute 'ALTER TABLE asset_balance_lists ADD PRIMARY KEY (id)'
  end
end
