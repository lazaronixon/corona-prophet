class CoronaDatum < ApplicationRecord
  scope :chronologically, -> { order :reported_at }
  scope :conformatively, -> { order confirmed: :desc }

  def color
    prophetized ? '#1a202c' : '#a0aec0'
  end

  class << self
    include ApplicationHelper

    def series_for(state, field)
      where(state: state).chronologically.map { |data| { 'ds' => data.reported_at, 'y' => data.send(field) } }
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
          pointBackgroundColor: where(state: state).chronologically.map(&:color),
          data: where(state: state).chronologically.pluck(field)
        }]
      }
    end
  end
end
