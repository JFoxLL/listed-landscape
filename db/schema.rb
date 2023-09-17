# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_09_17_225307) do
  create_table "lics", force: :cascade do |t|
    t.string "ticker"
    t.string "name"
    t.integer "market_cap"
    t.integer "listing_year"
    t.date "listing_date"
    t.integer "yrs_operating"
    t.string "investment_focus"
    t.string "portfolio_bias"
    t.string "benchmark"
    t.string "management_structure"
    t.string "investment_manager"
    t.string "management_fee"
    t.decimal "calculated_mer"
    t.string "performance_fee"
    t.text "objective"
    t.string "logo_filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
  end

end
