class RemoveStateFromCoronaDatum < ActiveRecord::Migration[6.0]
  def change
    remove_column :corona_data, :state, :string
    remove_column :corona_data, :population, :integer
  end
end
