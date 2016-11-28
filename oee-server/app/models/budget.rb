class Budget < ApplicationRecord
  self.inheritance_column = nil
  belongs_to :capex

  has_many :budget_items, dependent: :destroy
  has_many :pam_lists, dependent: :destroy
  has_many :pam_items, through: :pam_lists

  accepts_nested_attributes_for :budget_items, :allow_destroy => true
  accepts_nested_attributes_for :pam_lists, :allow_destroy => true
end
