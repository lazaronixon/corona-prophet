class CoronaDatum::Prophetizer
  def run
    CoronaDatum.unique_states.each do |state|
      puts "propheting #{state}..."
      confirmed = prophetize(state, :confirmed)
      deaths    = prophetize(state, :deaths)

      insert_data_from_prophet state, confirmed, deaths
    end
  end

  private
    def execute_script(path, *args)
      command = "#{r_executable_path} --vanilla #{Rails.root.join(path)} #{args.join(' ')}"
      output  = %x[#{command}]

      if output.present? then output else raise 'Unknown R error' end
    end

    def r_executable_path
      %x[which Rscript].chomp
    end

    def create_dataset_file_for(series)
      temp_file = Tempfile.create('dataset', Rails.root.join('tmp'))
      CSV.open(temp_file.path, 'wb') do |csv|
        csv << ['ds', 'y']
        series.each { |row| csv << row }
      end

      temp_file
    end

    def prophetize(state, field)
      series = CoronaDatum.series_for(state, field)
      dataset_file = create_dataset_file_for(series)

      parse_csv execute_script('forecasting.r', 7, dataset_file.path)
    end

    def parse_csv(string)
      CSV.parse string, headers: true
    end

    def insert_data_from_prophet(state, confirmed, deaths)
      confirmed_array = confirmed.map(&:to_h)
      deaths_array    = deaths.map(&:to_h)

      [confirmed_array, deaths_array].transpose.each do |confirmed_data, deaths_data|
        CoronaDatum.create!(reported_at: confirmed_data['ds'], state: state, confirmed: confirmed_data['yhat'], deaths: deaths_data['yhat'], prophetized: true)
      end
    end
end
