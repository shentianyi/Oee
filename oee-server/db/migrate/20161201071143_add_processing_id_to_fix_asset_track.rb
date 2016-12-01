class AddProcessingIdToFixAssetTrack < ActiveRecord::Migration[5.0]
  def change
    add_column :fix_asset_tracks, :processing_id, :string
  end
end
