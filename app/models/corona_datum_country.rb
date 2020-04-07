class CoronaDatumCountry < CoronaDatum
  class << self
    def datasource_for(field, label)
      datasource_data_for chronologically.last(DATA_SOURCE_DAYS), field, label
    end

    def summary
      find_by(reported_at: minimum_created_at)
    end
  end
end
