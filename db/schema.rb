# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170903004845) do

  create_table "cargo_legs", force: :cascade do |t|
    t.integer "cargo_cargo_id", null: false
    t.integer "voyage_voyage_id", null: false
    t.integer "load_location_id", null: false
    t.integer "unload_location_id", null: false
    t.datetime "load_time", null: false
    t.datetime "unload_time", null: false
    t.integer "leg_index", null: false
    t.index ["cargo_cargo_id"], name: "index_cargo_legs_on_cargo_cargo_id"
    t.index ["voyage_voyage_id"], name: "index_cargo_legs_on_voyage_voyage_id"
  end

  create_table "location_locations", force: :cascade do |t|
    t.string "un_locode", null: false
    t.string "name", null: false
  end

  create_table "voyage_carrier_movements", force: :cascade do |t|
    t.integer "voyage_voyage_id", null: false
    t.integer "departure_location_id", null: false
    t.integer "arrival_location_id", null: false
    t.datetime "arrival_time", null: false
    t.datetime "departure_time", null: false
    t.integer "cm_index", null: false
    t.index ["arrival_location_id"], name: "index_voyage_carrier_movements_on_arrival_location_id"
    t.index ["departure_location_id"], name: "index_voyage_carrier_movements_on_departure_location_id"
    t.index ["voyage_voyage_id"], name: "index_voyage_carrier_movements_on_voyage_voyage_id"
  end

  create_table "voyage_voyages", force: :cascade do |t|
    t.string "voyage_number", null: false
  end

end
