namespace :scheduler do
  task :update_corona_data => :environment do
    puts 'Updating corona data...'
    import_corona_data
    puts 'done'
  end

  private
    def import_corona_data
      puts 'importing data...'
      CoronaDatum::Importer.new.run
    end
end
