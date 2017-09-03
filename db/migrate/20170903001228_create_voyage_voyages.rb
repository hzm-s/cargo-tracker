class CreateVoyageVoyages < ActiveRecord::Migration[5.1]
  def change
    create_table :voyage_voyages do |t|
      t.string :voyage_number, null: false, unique: true
    end
  end
end
