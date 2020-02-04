# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
require_relative './app/models/application_record'
require_relative './app/models/restaurant'
require 'csv'

Rails.application.load_tasks

namespace :import do
  task :setup do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
  end

  task :restaurants do
    Rake::Task['import:setup'].invoke
    CSV.foreach('./Street Cafes 2015-16.csv', :headers => true, :encoding => "ISO-8859-1") do |row|
        new_resturant_data = row.to_hash
        new_resturant = Restaurant.create!(
          name:new_resturant_data["Café/Restaurant Name"],
          address:new_resturant_data["Street Address"],
          post_code:new_resturant_data["Post Code"],
          number_of_chairs:new_resturant_data["Number of Chairs"],
        )
        new_resturant.determine_category
    end
  end
end
