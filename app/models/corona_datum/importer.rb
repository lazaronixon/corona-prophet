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
        CoronaDatum.create! reported_at: row['date'], state: row['state'], population: row['estimated_population_2019'].to_i, confirmed: row['confirmed'].to_i, deaths: row['deaths'].to_i
      end
    end

    def extract_csv
      build_csv.select { |r| r['place_type'] == 'state' }
    end

    def build_csv
      CSV.new(build_zip_reader, headers: true)
    end

    def build_zip_reader
      Zlib::GzipReader.new(open(resource_url))
    end

    def resource_url
      'https://data.brasil.io/dataset/covid19/caso.csv.gz'
    end
end
