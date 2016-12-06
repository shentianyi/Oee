class AddTheWayToFixAssetTrack < ActiveRecord::Migration[5.0]
  def change
    add_column :fix_asset_tracks, :equip_create_way, :integer, default: 100
  end
end
