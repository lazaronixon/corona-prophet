class HomeController < ApplicationController
  def index
    @report = CoronaDatum.forecasted.where(state: 'SP').order(:reported_at)
  end
end
