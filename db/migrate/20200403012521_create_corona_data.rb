class CreateCoronaData < ActiveRecord::Migration[6.0]
  def change
    create_table :corona_data do |t|
      t.date :reported_at
      t.string :state
      t.integer :confirmed
      t.integer :deaths
    end
  end
end
