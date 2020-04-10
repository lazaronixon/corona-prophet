class CoronaDatumCountry < CoronaDatum
  class << self
    def confirmed_datasource
      datasource_data_for_confirmed chronologically
    end

    def deaths_datasource
      datasource_data_for_deaths chronologically
    end

    def summary
      find_by reported_at: CoronaDatum.prophetized_at
    end
  end
end
