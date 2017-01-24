class AddAssetStatusToPamItems < ActiveRecord::Migration[5.0]
  def change
    add_column :pam_items, :asset_status, :integer, default: 100
    add_column :pam_items, :remark, :string
  end
end
