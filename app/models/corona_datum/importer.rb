class CoronaDatum::Importer
  def run
    truncate_table
    persist_data_state_from_csv
    persist_data_country_from_csv
  end

  private
    def truncate_table
      CoronaDatum.delete_all
    end

    def persist_data_state_from_csv
      extract_csv(resource_state_url).each do |row|
        CoronaDatumState.create! reported_at: row['data'], state: find_or_initialize_state_by(row['estado']), confirmed: row['casos.acumulados'], deaths: row['obitos.acumulados']
      end
    end

    def persist_data_country_from_csv
      extract_csv(resource_br_url).each do |row|
        CoronaDatumCountry.create! reported_at: row['data'], confirmed: row['casos.acumulados'], deaths: row['obitos.acumulados']
      end
    end

    def find_or_initialize_state_by(name)
      State.find_or_initialize_by(name: name)
    end

    def extract_csv(resource_url)
      build_csv(resource_url).select { |r| r['casos.acumulados'].to_i > 0 }
    end

    def build_csv(resource_url)
      CSV.new(open(resource_url), headers: true)
    end

    def resource_state_url
      'https://raw.githubusercontent.com/covid19br/covid19br.github.io/master/dados/EstadosCov19.csv'
    end

    def resource_br_url
      'https://raw.githubusercontent.com/covid19br/covid19br.github.io/master/dados/BrasilCov19.csv'
    end
end
