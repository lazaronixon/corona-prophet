class CoronaDatumCountry < CoronaDatum
  class << self
    def datasource_for(field, label)
      datasource_data_for chronologically, field, label
    end

    def summary
      find_by(reported_at: CoronaDatum.prophetized_at)
    end
  end
end
