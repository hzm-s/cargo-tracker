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

ActiveRecord::Schema.define(version: 20170904071202) do

  create_table "cargo_cargos", force: :cascade do |t|
    t.string "tracking_id", null: false
    t.integer "origin_id", null: false
    t.integer "spec_origin_id", null: false
    t.integer "spec_destination_id", null: false
    t.date "spec_arrival_deadline", null: false
    t.string "transport_status", null: false
    t.integer "current_voyage_id"
    t.integer "last_known_location_id"
    t.boolean "misdirected", null: false
    t.string "routing_status", null: false
    t.datetime "calculated_at", null: false
    t.boolean "unloaded_at_dest", null: false
  end

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

  create_table "handling_handling_events", force: :cascade do |t|
    t.integer "cargo_cargo_id", null: false
    t.integer "voyage_voyage_id", null: false
    t.integer "location_location_id", null: false
    t.string "type", null: false
    t.datetime "completion_time", null: false
    t.datetime "registration_time", null: false
    t.index ["cargo_cargo_id"], name: "index_handling_handling_events_on_cargo_cargo_id"
    t.index ["location_location_id"], name: "index_handling_handling_events_on_location_location_id"
    t.index ["voyage_voyage_id"], name: "index_handling_handling_events_on_voyage_voyage_id"
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
