class Dashboards::StatesController < ApplicationController
  def show
    @state      = State.find(params[:id])
    @report     = CoronaDatum.find_by!(state: @state, reported_at: CoronaDatum.propheted_at)
    @confirmed  = CoronaDatum.datasource_state_for(@state, :confirmed, 'Confirmados')
    @deaths     = CoronaDatum.datasource_state_for(@state, :deaths, 'Mortes')
  end
end
