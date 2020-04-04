class CoronaDatum < ApplicationRecord
  scope :chronologically, -> { order :reported_at }
  scope :conformatively, -> { order confirmed: :desc }

  class << self
    include ApplicationHelper

    def series_for(state, field)
      where(state: state).chronologically.pluck(:reported_at, field)
    end

    def unique_states
      distinct.pluck(:state)
    end

    def summary_state
      where(reported_at: prophet_date).conformatively
    end

    def report_date
      where(prophetized: false).maximum(:reported_at)
    end

    def prophet_date
      where(prophetized: true).maximum(:reported_at)
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
