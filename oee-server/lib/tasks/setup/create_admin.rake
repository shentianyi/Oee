namespace :setup do
  desc 'Create Super User'
  task :create_admin => :environment do
    # puts '-----------start--------------'
    user=User.create(:name => 'admin', :email => 'admin@oee.com', :role => 100, :is_system => true, :password => "123456@")
    puts 'Default User Create Succ'

    # init oauth app
    unless Settings.default_app
      app=Doorkeeper::Application.new(name: Settings.oauth.application.name,
                                      uid: Settings.oauth.application.uid,
                                      redirect_uri: Settings.oauth.application.redirect_uri)
      app.owner = user
      app.save
    end

    # init first system user access token
    user.generate_access_token

    puts 'Default App Create Succ'
  end
end