class Capex < ApplicationRecord
  has_many :budgets, dependent: :destroy
end
