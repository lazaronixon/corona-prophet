class HomeController < ApplicationController
  def index
    @report = CoronaDatum.where(state: 'GO').order(:reported_at)
  end
end
