module ApplicationHelper
  def page_title
    content_for(:page_title) || Rails.application.class.to_s.split('::').first
  end

  def minimum_reported_at
    CoronaDatum.minimum_reported_at
  end
end
