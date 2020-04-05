class Dashboards::StatesController < ApplicationController
  def show
    @report       = CoronaDatum.find_by!(state: params[:id], reported_at: CoronaDatum.prophet_date)
    @confirmed    = CoronaDatum.datasource_for(params[:id], :confirmed, 'Confirmados')
    @deaths       = CoronaDatum.datasource_for(params[:id], :deaths, 'Mortes')
    @prophet_date = CoronaDatum.prophet_date
  end
end
