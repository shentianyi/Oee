class AddAncestryToFixAssetTrack < ActiveRecord::Migration[5.0]
  def change
    add_column :fix_asset_tracks, :ancestry, :string
    add_index :fix_asset_tracks, :ancestry
  end
end
