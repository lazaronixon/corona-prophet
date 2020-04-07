class DashboardsController < ApplicationController
  def index
    @report         = CoronaDatumState.summary
    @report_country = CoronaDatumCountry.summary
  end
end
