class CoronaDatum::Prophetizer
  def run
    forecast_states
    forecast_country
  end

  private
    FORECASTING_DAYS = 21

    def forecast_states
      State.all.each do |state|
        confirmed = process_state_confirmed_for(state)
        deaths    = process_state_deaths_for(state)

        insert_state_data_from_prophet confirmed, deaths, state
      end
    end

    def forecast_country
      confirmed = process_country_confirmed
      deaths    = process_country_deaths

      insert_country_data_from_prophet confirmed, deaths
    end

    def process_state_confirmed_for(state)
      post_time_series_confirmed state_time_series_confirmed_for(state)
    end

    def process_state_deaths_for(state)
      post_time_series_deaths state_time_series_deaths_for(state)
    end

    def process_country_confirmed
      post_time_series_confirmed country_time_series_confirmed
    end

    def process_country_deaths
      post_time_series_deaths country_time_series_deaths
    end

    def country_time_series_deaths
      CoronaDatumCountry.confirmed.chronologically.map { |d| { 'ds' => d.reported_at, 'y' => d.deaths } }
    end

    def country_time_series_confirmed
      CoronaDatumCountry.chronologically.map { |d| { 'ds' => d.reported_at, 'y' => d.confirmed } }
    end

    def state_time_series_deaths_for(state)
      CoronaDatumState.where(state: state).confirmed.chronologically.map { |d| { 'ds' => d.reported_at, 'y' => d.deaths } }
    end

    def state_time_series_confirmed_for(state)
      CoronaDatumState.where(state: state).chronologically.map { |d| { 'ds' => d.reported_at, 'y' => d.confirmed } }
    end

    def post_time_series_confirmed(time_series)
      decode http.send(:post, '/confirmed', encode(time_series), headers).body
    end

    def post_time_series_deaths(time_series)
      decode http.send(:post, '/deaths', encode(time_series), headers).body
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
