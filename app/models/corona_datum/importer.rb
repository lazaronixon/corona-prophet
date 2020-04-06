class CoronaDatum::Importer
  def run
    truncate_table
    persist_data_from_csv
  end

  private
    def truncate_table
      CoronaDatum.delete_all
    end

    def persist_data_from_csv
      extract_csv.each do |row|
        CoronaDatum.create! reported_at: row['Date'], state: find_or_initialize_state_by(row['RegionCode'], row['Population']), confirmed: row['Confirmed'].to_i, deaths: row['Deaths'].to_i
      end
    end

    def find_or_initialize_state_by(name, population)
      State.find_or_initialize_by(name: name) do |state|
        state.name = name
        state.population = population
      end
    end

    def extract_csv
      build_csv.select { |r| r['CountryCode'] == 'BR' && r['RegionCode'].present? }
    end

    def build_csv
      CSV.new(open(resource_url), headers: true)
    end

    def resource_url
      'https://open-covid-19.github.io/data/data.csv'
    end
end
