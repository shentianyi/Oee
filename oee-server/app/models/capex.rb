class Capex < ApplicationRecord
  has_many :budgets, dependent: :destroy
  # has_many :budget_items, through: :budgets
end
