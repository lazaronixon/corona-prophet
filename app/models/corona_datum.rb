class CoronaDatum < ApplicationRecord
  scope :chronologically, -> { order :reported_at }
  scope :conformatively,  -> { order confirmed: :desc }

  def color
    prophetized? ? '#1a202c' : '#a0aec0'
  end

  def maximum_confirmed_top
    maximum()
  end

  class << self
    def prophetized_at
      where(prophetized: true).minimum(:reported_at).in_time_zone.to_date
    end

    private
      def deaths_datasource_data_for(relation)
        { labels: relation.pluck(:reported_at), datasets: [{ label: 'Mortes', pointBackgroundColor: relation.map(&:color), data: relation.pluck(:deaths) }] }
      end

      def confirmed_datasource_data_for(relation, confirmed_top)
        {
          labels: relation.pluck(:reported_at),
          datasets: [{
            label: 'Confirmados',
            pointBackgroundColor: relation.map(&:color),
            data: relation.pluck(:confirmed)
          }
        }
      end
  end
end
