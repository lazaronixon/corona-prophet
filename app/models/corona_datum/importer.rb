class CoronaDatum::Importer
  def run
    truncate_table
    insert_data_from_api
  end

  private
    def truncate_table
      CoronaDatum.delete_all
    end

    def insert_data_from_api
      results = request_data['results']
      mapped_attributes = map_attributes_for(results)

      CoronaDatum.insert_all! mapped_attributes
    end

    def request_data
       decode Net::HTTP.get(resource_uri)
    end

    def map_attributes_for(response)
      response.collect { |resp| { reported_at: resp['date'], state: resp['state'], confirmed: resp['confirmed'], deaths: resp['deaths'] } }
    end

    def decode(string)
      ActiveSupport::JSON.decode(string)
    end

    def resource_uri
      URI('https://brasil.io/api/dataset/covid19/caso/data?place_type=state')
    end
end
