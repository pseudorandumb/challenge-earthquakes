require 'standalone_migrations'
StandaloneMigrations::Tasks.load_tasks
require './environment'

namespace :earthquakes do
  desc "Retrieve last 30 days of earthquake data and store/update it locally."
  task :update_local do
    Earthquake.update_stored_earthquakes
  end
end