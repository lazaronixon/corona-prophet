class ProphetizerJob < ApplicationJob
  queue_as :default

  def perform
    import_corona_data
    enrich_corona_data
  end

  private
    def import_corona_data
      CoronaDatum::Importer.new.run
    end

    def enrich_corona_data
      CoronaDatum::Prophetizer.new.run
    end
end
