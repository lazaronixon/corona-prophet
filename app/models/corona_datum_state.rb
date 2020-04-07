class CoronaDatumState < CoronaDatum
  belongs_to :state

  class << self
    def datasource_for(state, field, label)
      datasource_data_for where(state: state).chronologically.last(DATA_SOURCE_DAYS), field, label
    end

    def series_for(state, field)
      where(state: state).chronologically.map { |data| { 'ds' => data.reported_at, 'y' => data.send(field) } }
    end

    def summary
      where(reported_at: propheted_at).conformatively
    end
  end
end
