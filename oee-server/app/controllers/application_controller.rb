class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper

  before_action :set_model
  before_action :require_user

  before_action :set_current_controller_and_action

  protected

  def require_user
    if current_user.blank?
      respond_to do |format|
        format.html { authenticate_user! }
        format.all { head(:unauthorized) }
      end
    end
  end

  def set_current_controller_and_action
    @current_controller=self.controller_name
    @current_action=self.action_name
    @current_model=self.class.name.gsub(/Controller/, '').tableize.singularize
  end

  private
  def set_model
    @model=self.class.name.gsub(/Controller/, '').tableize.singularize
  end

  def model
    self.class.name.gsub(/Controller/, '').classify.constantize
  end
end
