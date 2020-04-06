class Dashboards::StatesController < ApplicationController
  def show
    @report       = CoronaDatum.find_by!(state: params[:id], reported_at: Date.current)
    @confirmed    = CoronaDatum.datasource_state_for(params[:id], :confirmed, 'Confirmados')
    @deaths       = CoronaDatum.datasource_state_for(params[:id], :deaths, 'Mortes')
  end
end
