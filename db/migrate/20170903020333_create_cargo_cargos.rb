class CreateCargoCargos < ActiveRecord::Migration[5.1]
  def change
    create_table :cargo_cargos do |t|
      t.string :tracking_id, null: false, unique: true
      t.integer :origin_id, null: false
      t.integer :spec_origin_id, null: false
      t.integer :spec_destination_id, null: false
      t.date :spec_arrival_deadline, null: false
      t.string :transport_status, null: false
      t.integer :current_voyage_id
      t.integer :last_known_location_id
      t.boolean :misdirected, null: false
      t.string :routing_status, null: false
      t.datetime :calculated_at, null: false
      t.boolean :unloaded_at_dest, null: false
    end

    add_foreign_key :cargo_cargos, :location_locations, column: :origin_id
    add_foreign_key :cargo_cargos, :location_locations, column: :spec_origin_id
    add_foreign_key :cargo_cargos, :location_locations, column: :spec_destination_id
    add_foreign_key :cargo_cargos, :voyage_voyages, column: :current_voyage_id
    add_foreign_key :cargo_cargos, :location_locations, column: :last_known_location_id
  end
end
