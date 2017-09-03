class CreateCargoLegs < ActiveRecord::Migration[5.1]
  def change
    create_table :cargo_legs do |t|
      t.references :cargo_cargo, null: false, foreign_key: true
      t.references :voyage_voyage, null: false, foreign_key: true
      t.integer :load_location_id, null: false, foreign_key: true
      t.integer :unload_location_id, null: false, foreign_key: true
      t.datetime :load_time, null: false
      t.datetime :unload_time, null: false
      t.integer :leg_index, null: false
    end

    add_foreign_key :cargo_legs, :location_locations, column: :load_location_id
    add_foreign_key :cargo_legs, :location_locations, column: :unload_location_id
  end
end
