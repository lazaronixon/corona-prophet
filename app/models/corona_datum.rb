class CoronaDatum < ApplicationRecord
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
      def datasource_data_for(relation, column)
        { labels: relation.pluck(:reported_at), datasets: [{ label: column == :confirmed ? 'Confirmados' : 'Mortes', pointBackgroundColor: relation.map(&:color), data: relation.pluck(column) }] }
      end
  end
end
