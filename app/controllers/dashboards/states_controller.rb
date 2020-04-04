class Dashboards::StatesController < ApplicationController
  def show
    @report    = CoronaDatum.where(state: params[:id], reported_at: CoronaDatum.prophet_date).take
    @confirmed = CoronaDatum.datasource_for(params[:id], :confirmed, 'Confirmados')
    @deaths    = CoronaDatum.datasource_for(params[:id], :deaths, 'Mortes')
  end
end
