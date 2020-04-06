class CoronaDatum < ApplicationRecord
  scope :chronologically, -> { order :reported_at }
  scope :conformatively, -> { order confirmed: :desc }

  belongs_to :state

  def color
    prophetized? ? '#1a202c' : '#a0aec0'
  end

  class << self
    include ApplicationHelper

    DATA_SOURCE_DAYS = 25

    def propheted_at
      minimum(:created_at).to_date
    end

    def series_for(state, field)
      where(state: state).chronologically.map { |data| { 'ds' => data.reported_at, 'y' => data.send(field) } }
    end

    def summary_state
      where(reported_at: propheted_at).conformatively
    end

    def datasource_state_for(state, field, label)
      datasource_data_for where(state: state).chronologically.last(DATA_SOURCE_DAYS), field, label
    end

    def datasource_country_for(field, label)
      datasource_data_for \
        select('reported_at, prophetized, SUM(confirmed) AS confirmed, SUM(deaths) AS deaths').group(:reported_at, :prophetized).chronologically.last(DATA_SOURCE_DAYS), field, label
    end

    private
      def datasource_data_for(relation, field, label)
        { labels: relation.pluck(:reported_at), datasets: [{ label: label, pointRadius: 6, pointBackgroundColor: relation.map(&:color), data: relation.pluck(field) }] }
      end
  end
end
