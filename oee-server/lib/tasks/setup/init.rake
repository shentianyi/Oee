namespace :setup do
  desc 'set up all data one by one'
  task :init => :environment do
    puts '====== 1.create admin'
    Rake::Task['setup:create_admin'].invoke

    # puts '====== 1.2 create default app'
    # Rake::Task['setup:create_app'].invoke

  end
end