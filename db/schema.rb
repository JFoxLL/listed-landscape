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

ActiveRecord::Schema[7.0].define(version: 2023_09_22_232420) do
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

  create_table "number_shareholders", force: :cascade do |t|
    t.string "lic_ticker"
    t.string "lic_name"
    t.integer "year"
    t.integer "number_shareholders"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lic_id"
  end

  create_table "share_price_vs_nta", force: :cascade do |t|
    t.string "lic_ticker"
    t.string "lic_name"
    t.date "month_year"
    t.decimal "share_price"
    t.decimal "pre_tax_nta"
    t.decimal "post_tax_nta"
    t.decimal "sp_vs_pre_tax_nta"
    t.decimal "sp_vs_post_tax_nta"
    t.integer "lic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lic_id"], name: "index_share_price_vs_nta_on_lic_id"
  end

  create_table "size_net_assets", force: :cascade do |t|
    t.string "lic_ticker"
    t.string "lic_name"
    t.integer "year"
    t.integer "size_net_assets"
    t.integer "lic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lic_id"], name: "index_size_net_assets_on_lic_id"
  end

  add_foreign_key "share_price_vs_nta", "lics"
  add_foreign_key "size_net_assets", "lics"
end
