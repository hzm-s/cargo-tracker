class CreateLocationLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :location_locations do |t|
      t.string :un_locode, null: false, unique: true
      t.string :name, null: false
    end
  end
end
