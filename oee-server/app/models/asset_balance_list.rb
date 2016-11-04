class AssetBalanceList < ApplicationRecord
  validates_uniqueness_of :id
  # after_initialize :generate_id
  before_create :generate_id

  has_many :asset_balance_items

  def generate_id
    self.id = "ZC#{Time.now.strftime('%Y%m%d%H%M%S')}"
  end
end
