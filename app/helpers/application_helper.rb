module ApplicationHelper
  def page_title
    content_for(:page_title) || Rails.application.class.to_s.split('::').first
  end

  def propheted_at
    CoronaDatum.minimum(:created_at).in_time_zone.to_date
  end
end
