class PamList < ApplicationRecord
  belongs_to :budget

  has_many :pam_items, dependent: :destroy

  accepts_nested_attributes_for :pam_items, :allow_destroy => true
end
