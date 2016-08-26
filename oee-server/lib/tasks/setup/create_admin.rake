namespace :setup do
  desc 'Create Super User'
  task :create_admin => :environment do
    # puts '-----------start--------------'
    user=User.create(:name => 'admin', :email => 'admin@oee.com', :role => 100, :is_system => true, :password => "123456@")
    puts '-----------succ--------------'
  end
end