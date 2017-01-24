class AddAssetIdsToPamItems < ActiveRecord::Migration[5.0]
  def change
    add_column :pam_items, :asset_nrs, :string
  end
end
