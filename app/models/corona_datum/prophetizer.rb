class CoronaDatum::Prophetizer
  def run
    forecast_states
    forecast_country
  end

  private
    FORECASTING_DAYS = 7

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
      result = post_time_series_to_solver(state_time_series_for(state, field))
      result = cumsum_time_series(result)
      result.last FORECASTING_DAYS
    end

    def process_country(field)
      result = post_time_series_to_solver(country_time_series_for(field))
      result = cumsum_time_series(result)
      result.last FORECASTING_DAYS
    end

    def country_time_series_for(field)
      diff_time_series CoronaDatumCountry.chronologically.map { |data| { 'ds' => data.reported_at, 'y' => data.send(field) } }
    end

    def state_time_series_for(state, field)
      diff_time_series CoronaDatumState.where(state: state).chronologically.map { |data| { 'ds' => data.reported_at, 'y' => data.send(field) } }
    end

    def post_time_series_to_solver(time_series)
      decode http.send(:post, '/prophet', encode(time_series), headers).body
    end

    def insert_state_data_from_prophet(confirmed, deaths, state)
      [confirmed, deaths].transpose.each do |confirmed_data, deaths_data|
        CoronaDatumState.create!(reported_at: confirmed_data['ds'], state: state, confirmed: confirmed_data['yhat'], deaths: deaths_data['yhat'], prophetized: true)
      end
    end

    def insert_country_data_from_prophet(confirmed, deaths)
      [confirmed, deaths].transpose.each do |confirmed_data, deaths_data|
        CoronaDatumCountry.create!(reported_at: confirmed_data['ds'], confirmed: confirmed_data['yhat'], deaths: deaths_data['yhat'], prophetized: true)
      end
    end

    def diff_time_series(time_series)
      [ time_series.first, *time_series.each_cons(2).map { |prev, curr| { 'ds' => curr['ds'], 'y' => curr['y'] - prev['y'] } } ]
    end

    def cumsum_time_series(time_series)
      sum = 0; time_series.map { |curr| { 'ds' => curr['ds'], 'yhat' => sum += curr['yhat'] } }
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
