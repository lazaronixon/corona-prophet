class Dashboards::StatesController < ApplicationController
  def show
    @report    = CoronaDatum.where(state: params[:id], reported_at: Date.current + 6.days).take
    @confirmed = CoronaDatum.datasource_for(params[:id], :confirmed, 'Confirmados')
    @deaths    = CoronaDatum.datasource_for(params[:id], :deaths, 'Mortes')
  end
end
