class CoronaDatum < ApplicationRecord
  scope :confirmed, -> { where 'confirmed > 0' }
  scope :chronologically, -> { order :reported_at }
  scope :conformatively,  -> { order confirmed: :desc }

  def color
    prophetized? ? '#1a202c' : '#a0aec0'
  end

  class << self
    def prophetized_at
      where(prophetized: true).minimum(:reported_at).in_time_zone.to_date
    end

    private
      def datasource_data_for_confirmed(relation)
        {
          labels: relation.pluck(:reported_at),
          datasets: [
            { label: 'Confirmados', pointBackgroundColor: relation.map(&:color), data: relation.pluck(:confirmed) },
            { label: 'Pico de contágio', borderDash: [5, 5], borderColor: '#1a202c', pointRadius: 0, fill: false, data: relation.pluck(:confirmed_top) }
          ]
        }
      end

      def datasource_data_for_deaths(relation)
        { labels: relation.pluck(:reported_at), datasets: [{ label: 'Mortes', pointBackgroundColor: relation.map(&:color), data: relation.pluck(:deaths) }] }
      end
  end
end
