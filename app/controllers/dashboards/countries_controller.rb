class Dashboards::CountriesController < ApplicationController
  def show
    @report     = CoronaDatumCountry.find_by!(reported_at: CoronaDatum.minimum_created_at)
    @confirmed  = CoronaDatumCountry.datasource_for(:confirmed, 'Confirmados')
    @deaths     = CoronaDatumCountry.datasource_for(:deaths, 'Mortes')
  end
end
