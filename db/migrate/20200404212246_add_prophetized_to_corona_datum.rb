class AddProphetizedToCoronaDatum < ActiveRecord::Migration[6.0]
  def change
    add_column :corona_data, :prophetized, :boolean, default: false
  end
end
