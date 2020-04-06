class AddStateReferencesToCoronaDatum < ActiveRecord::Migration[6.0]
  def change
    add_reference :corona_data, :state, null: false, foreign_key: false
  end
end
