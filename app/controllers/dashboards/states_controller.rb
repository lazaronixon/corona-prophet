class Dashboards::StatesController < ApplicationController
  def show
    @state      = State.find(params[:id])
    @report     = CoronaDatumState.find_by!(state: @state, reported_at: CoronaDatum.propheted_at)
    @confirmed  = CoronaDatumState.datasource_for(@state, :confirmed, 'Confirmados')
    @deaths     = CoronaDatumState.datasource_for(@state, :deaths, 'Mortes')
  end
end
