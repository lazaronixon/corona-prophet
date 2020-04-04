namespace :scheduler do
  task :update_corona_data => :environment do
    puts 'Updating corona data...'
    import_corona_data
    enrich_corona_data
    puts 'done'
  end

  private
    def import_corona_data
      puts 'importing data...'
      CoronaDatum::Importer.new.run
    end

    def enrich_corona_data
      puts 'enriching data...'
      CoronaDatum::Prophetizer.new.run
    end
end
