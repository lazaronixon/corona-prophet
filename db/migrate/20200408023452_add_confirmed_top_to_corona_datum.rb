class AddConfirmedTopToCoronaDatum < ActiveRecord::Migration[6.0]
  def change
    add_column :corona_data, :confirmed_top, :integer
  end
end
