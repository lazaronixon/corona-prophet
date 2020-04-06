class CoronaDatum::Prophetizer
  def run
    State.all.each do |state|
      confirmed = prophetize(state, :confirmed)
      deaths    = prophetize(state, :deaths)

      insert_data_from_prophet state, confirmed, deaths
    end
  end

  private
    FORECASTING_DAYS = 14

    def prophetize(state, field)
      series   = CoronaDatum.series_for(state, field)
      response = post_series_to_solver(series)
    end

    def post_series_to_solver(series)
      decode http.send(:post, '/prophet', encode(series), headers).body
    end

    def insert_data_from_prophet(state, confirmed, deaths)
      [confirmed, deaths].transpose.each do |confirmed_data, deaths_data|
        CoronaDatum.create!(reported_at: confirmed_data['ds'], state: state, confirmed: confirmed_data['yhat'], deaths: deaths_data['yhat'], prophetized: true)
      end
    end

    def http
      new_http = Net::HTTP.new(resource_uri.host, resource_uri.port)
      new_http.use_ssl = resource_uri.is_a?(URI::HTTPS)
      new_http
    end

    def resource_uri
      URI('https://corona-prophet-solver.herokuapp.com')
    end

    def decode(string)
      ActiveSupport::JSON.decode(string)
    end

    def encode(object)
      ActiveSupport::JSON.encode(object)
    end

    def headers
      { 'Content-Type' => 'application/json', 'periods' => FORECASTING_DAYS.to_s }
    end
end
