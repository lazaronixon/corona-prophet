class Dashboards::CountriesController < ApplicationController
  def show
    @report     = CoronaDatumCountry.find_by!(reported_at: CoronaDatum.prophetized_at)
    @confirmed  = CoronaDatumCountry.confirmed_datasource
    @deaths     = CoronaDatumCountry.deaths_datasource
  end
end
