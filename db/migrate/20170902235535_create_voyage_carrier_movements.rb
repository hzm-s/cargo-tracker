class CreateVoyageCarrierMovements < ActiveRecord::Migration[5.1]
  def change
    create_table :voyage_carrier_movements do |t|
      t.references :voyage_voyage, null: false, foreign_key: true
      t.integer :departure_location_id, null: false, index: true
      t.integer :arrival_location_id, null: false, index: true
      t.datetime :arrival_time, null: false
      t.datetime :departure_time, null: false
      t.integer :cm_index, null: false
    end

    add_foreign_key :voyage_carrier_movements, :location_locations, column: :arrival_location_id
    add_foreign_key :voyage_carrier_movements, :location_locations, column: :departure_location_id
  end
end
