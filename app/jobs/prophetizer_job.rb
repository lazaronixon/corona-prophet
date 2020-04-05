class ProphetizerJob < ApplicationJob
  queue_as :default

  def perform
    ActiveRecord::Base.transaction do
      import_corona_data
      enrich_corona_data
    end
  end

  private
    def import_corona_data
      CoronaDatum::Importer.new.run
    end

    def enrich_corona_data
      CoronaDatum::Prophetizer.new.run
    end
end
