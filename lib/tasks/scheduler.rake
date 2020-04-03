namespace :scheduler do
  task :update_corona_data => :environment do
    puts 'Updating corona data...'
    import_corona_data
    prophesy_corona_data
    puts 'done'
  end

  private
    def import_corona_data
      puts 'importing data...'
      CoronaDatum::Importer.new.run
    end

    def prophesy_corona_data
      puts 'propheting data...'
      CoronaDatum::Prophetizer.new.run
    end
end
