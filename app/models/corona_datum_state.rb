class CoronaDatumState < CoronaDatum
  belongs_to :state

  class << self
    def confirmed_datasource_for(state)
      datasource_data_for_confirmed where(state: state).confirmed.chronologically
    end

    def deaths_datasource_for(state)
      datasource_data_for_deaths where(state: state).confirmed.chronologically
    end

    def summary
      where(reported_at: CoronaDatum.prophetized_at).conformatively
    end
  end
end
