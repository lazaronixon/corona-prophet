class CoronaDatum < ApplicationRecord
  scope :chronologically, -> { order :reported_at }
  scope :conformatively,  -> { order confirmed: :desc }

  def color
    prophetized? ? '#1a202c' : '#a0aec0'
  end

  class << self
    include ApplicationHelper

    DATA_SOURCE_DAYS = 25

    def minimum_created_at
      minimum(:created_at).in_time_zone.to_date
    end

    private
      def datasource_data_for(relation, field, label)
        { labels: relation.pluck(:reported_at), datasets: [{ label: label, pointRadius: 6, pointHoverRadius: 7, pointBackgroundColor: relation.map(&:color), data: relation.pluck(field) }] }
      end
  end
end
