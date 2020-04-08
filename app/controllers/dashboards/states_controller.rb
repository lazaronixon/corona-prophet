class Dashboards::StatesController < ApplicationController
  def show
    @state      = State.find(params[:id])
    @report     = CoronaDatumState.find_by!(state: @state, reported_at: CoronaDatum.prophetized_at)
    @confirmed  = CoronaDatumState.confirmed_datasource_for(@state)
    @deaths     = CoronaDatumState.deaths_datasource_for(@state)
  end
end
