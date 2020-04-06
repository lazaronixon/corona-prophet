class AddPopulationToCoronaDatum < ActiveRecord::Migration[6.0]
  def change
    add_column :corona_data, :population, :integer
  end
end
