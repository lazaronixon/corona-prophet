class CoronaDatumState < CoronaDatum
  belongs_to :state

  class << self
    def datasource_for(state, field, label)
      datasource_data_for where(state: state).chronologically, field, label
    end

    def summary
      where(reported_at: CoronaDatum.minimum_reported_at).conformatively
    end
  end
end
