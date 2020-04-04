class DashboardsController < ApplicationController
  def index
    @report = CoronaDatum.summary_state
  end
end
