namespace :scheduler do
  task :update_corona_data => :environment do  
    ProphetizerJob.perform_later
  end
end
