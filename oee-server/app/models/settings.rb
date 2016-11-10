class Settings < Settingslogic
  source "#{Rails.root}/config/application.yml"
  namespace Rails.env

  def self.default_app
    Doorkeeper::Application.by_uid(Settings.oauth.application.uid)
  end
end