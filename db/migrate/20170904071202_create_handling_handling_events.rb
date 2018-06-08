class CreateHandlingHandlingEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :handling_handling_events do |t|
      t.references :cargo_cargo, null: false, foreign_key: true
      t.references :voyage_voyage, null: false, foreign_key: true
      t.references :location_location, null: false, foreign_key: true
      t.string :type, null: false
      t.datetime :completion_time, null: false
      t.datetime :registration_time, null: false
    end
  end
end
