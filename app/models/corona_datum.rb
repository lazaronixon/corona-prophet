class CoronaDatum < ApplicationRecord
  scope :chronologically, -> { order :reported_at }
  scope :conformatively, -> { order confirmed: :desc }

  class << self
    def series_for(state, field)
      where(state: state).chronologically.pluck(:reported_at, field)
    end

    def unique_states
      distinct.pluck(:state)
    end

    def summary_state
      where(reported_at: Date.current + 6.days).conformatively
    end

    def datasource_for(state, field, label)
      {
        labels: where(state: state).chronologically.pluck(:reported_at),
        datasets: [{
          label: label,
          data: where(state: state).chronologically.pluck(field)
        }]
      }
    end
  end
end
