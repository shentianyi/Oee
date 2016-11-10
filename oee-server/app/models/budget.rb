class Budget < ApplicationRecord
  self.inheritance_column = nil
  belongs_to :capex

  has_many :budget_items, dependent: :destroy
end
