class Capex < ApplicationRecord
  has_many :budgets, dependent: :destroy
  # has_many :budget_items, through: :budgets
  accepts_nested_attributes_for :budgets, :allow_destroy => true
end
