class CoronaDatumState < CoronaDatum
  belongs_to :state

  class << self
    def confirmed_datasource_for(state)
      datasource_data_for where(state: state).chronologically, :confirmed
    end

    def deaths_datasource_for(state)
      datasource_data_for where(state: state).chronologically, :deaths
    end

    def summary
      where(reported_at: CoronaDatum.prophetized_at).conformatively
    end
  end
end
