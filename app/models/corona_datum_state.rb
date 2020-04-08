class CoronaDatumState < CoronaDatum
  belongs_to :state

  class << self
    def confirmed_datasource_for(state)
      confirmed_datasource_data_for where(state: state).chronologically, where(state: state).maximum(:confirmed_top)
    end

    def deaths_datasource_for(state)
      deaths_datasource_data_for where(state: state).chronologically
    end

    def summary
      where(reported_at: CoronaDatum.prophetized_at).conformatively
    end
  end
end
