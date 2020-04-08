module ApplicationHelper
  def page_title
    content_for(:page_title) || Rails.application.class.to_s.split('::').first
  end

  def prophetized_at
    CoronaDatum.prophetized_at
  end
end
