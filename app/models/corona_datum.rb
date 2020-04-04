class CoronaDatum < ApplicationRecord
  def self.series_for(state, field)
    where(state: state).order(:reported_at).pluck(:reported_at, field)
  end

  def self.unique_states
    distinct.pluck(:state)
  end
end
