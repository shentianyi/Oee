class Budget < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :capex
  has_many :budget_items, dependent: :destroy
  has_many :pam_lists, dependent: :destroy
  has_many :pam_items, through: :pam_lists

  validates_uniqueness_of :code, :message => "Budget Code 已存在!"

  accepts_nested_attributes_for :budget_items, :allow_destroy => true
  accepts_nested_attributes_for :pam_lists, :allow_destroy => true

  def pam_final_approved
    self.pam_lists.pluck(:approved).reduce(0){|total, val| total += val.to_f}
  end

  def pam_approval_in_process
    self.pam_lists.pluck(:in_process).reduce(0){|total, val| total += val.to_f}
  end

  def pam_not_start_to_approve
    self.pam_lists.pluck(:budget_not_applied).reduce(0){|total, val| total += val.to_f}
  end

  def sum_pams_column column
    self.pam_lists.pluck(column).reduce(0){|total, val| total += val.to_f}
  end

  def sum_pam_items_cloumn column
    self.pam_lists.map{|l| l.pam_items.pluck(column).reduce(0){|lt, lv| lt+=lv.to_f}}.reduce(0){|it, iv| it+=iv.to_f}
  end

  def latest_budget_item
    self.budget_items.where("total_price > 0").order(created_at: :desc).first
  end

end





