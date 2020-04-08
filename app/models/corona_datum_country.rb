class CoronaDatumCountry < CoronaDatum
  class << self
    def confirmed_datasource
      confirmed_datasource_data_for chronologically, maximum(:confirmed_top)
    end

    def deaths_datasource
      deaths_datasource_data_for chronologically
    end

    def summary
      find_by(reported_at: CoronaDatum.prophetized_at)
    end
  end
end
