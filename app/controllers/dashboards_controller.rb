class DashboardsController < ApplicationController
  def index
    @report       = CoronaDatum.summary_state
    @prophet_date = CoronaDatum.prophet_date
  end
end
