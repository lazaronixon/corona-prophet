class AddDeahtsTopToCoronaDatum < ActiveRecord::Migration[6.0]
  def change
    add_column :corona_data, :deaths_top, :integer
  end
end
