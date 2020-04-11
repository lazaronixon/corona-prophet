class CoronaDatum::Prophetizer
  def run
    forecast_states
    forecast_country
  end

  private
    FORECASTING_DAYS = 21

    def forecast_states
      State.all.each do |state|
        confirmed = process_state(:confirmed, state)
        deaths    = process_state(:deaths, state)

        insert_state_data_from_prophet confirmed, deaths, state
      end
    end

    def forecast_country
      confirmed = process_country(:confirmed)
      deaths    = process_country(:deaths)

      insert_country_data_from_prophet confirmed, deaths
    end

    def process_state(field, state)
      post_time_series state_time_series_for(state, field), field
    end

    def process_country(field)
      post_time_series country_time_series_for(field), field
    end

    def country_time_series_for(field)
      CoronaDatumCountry.chronologically.map { |data| { 'ds' => data.reported_at, 'y' => data.send(field) } }
    end

    def state_time_series_for(state, field)
      CoronaDatumState.where(state: state).chronologically.map { |data| { 'ds' => data.reported_at, 'y' => data.send(field) } }
    end

    def post_time_series(time_series, field)
      decode http.send(:post, "/#{field}", encode(time_series), headers).body
    end

    def insert_state_data_from_prophet(confirmed, deaths, state)
      [confirmed, deaths].transpose.each do |confirmed_data, deaths_data|
        CoronaDatumState.create! state: state, reported_at: confirmed_data['ds'], confirmed: confirmed_data['yhat'], confirmed_top: confirmed_data['cap'], deaths: deaths_data['yhat'], prophetized: true
      end
    end

    def insert_country_data_from_prophet(confirmed, deaths)
      [confirmed, deaths].transpose.each do |confirmed_data, deaths_data|
        CoronaDatumCountry.create! reported_at: confirmed_data['ds'], confirmed: confirmed_data['yhat'], confirmed_top: confirmed_data['cap'], deaths: deaths_data['yhat'], prophetized: true
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
