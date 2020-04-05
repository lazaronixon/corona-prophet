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
      where(reported_at: Date.current).conformatively
    end

    def datasource_for(state, field, label)
      result = where(state: state).chronologically.last(20)

      {
        labels: result.pluck(:reported_at),
        datasets: [{
          label: label,
          pointBackgroundColor: result.map(&:color),
          data: result.pluck(field)
        }]
      }
    end
  end
end
