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

ActiveRecord::Schema[7.1].define(version: 2024_01_24_223645) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "annual_reports", force: :cascade do |t|
    t.string "lic_ticker"
    t.string "lic_name"
    t.integer "year"
    t.string "annual_report_filename"
    t.integer "lic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "common_questions", force: :cascade do |t|
    t.string "lic_ticker"
    t.string "lic_name"
    t.integer "lic_id"
    t.text "q1_q"
    t.text "q1_a"
    t.text "q2_q"
    t.text "q2_a"
    t.text "q3_q"
    t.text "q3_a"
    t.text "q4_q"
    t.text "q4_a"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dividend_comparisons", force: :cascade do |t|
    t.string "lic_ticker"
    t.string "lic_name"
    t.integer "year"
    t.integer "dividend_income"
    t.integer "distribution_income"
    t.integer "foreign_income"
    t.integer "dividends_paid_short"
    t.integer "interest_income"
    t.integer "interest_paid"
    t.integer "total_income"
    t.integer "dividends_paid"
    t.integer "lic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dividend_histories", force: :cascade do |t|
    t.string "lic_ticker"
    t.string "lic_name"
    t.integer "year"
    t.date "ex_date"
    t.date "payment_date"
    t.string "dividend_type"
    t.string "dividend_phase"
    t.decimal "cash_amount"
    t.decimal "franking_level"
    t.decimal "corp_tax_rate"
    t.decimal "franking_credit_amount"
    t.decimal "grossed_up_amount"
    t.decimal "drp_price"
    t.integer "lic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dividend_yields", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.string "lic_ticker"
    t.string "lic_name"
    t.integer "year"
    t.string "expense"
    t.string "expense_category"
    t.integer "expense_amount"
    t.integer "lic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "key_people", force: :cascade do |t|
    t.string "lic_ticker"
    t.string "lic_name"
    t.integer "year_updated"
    t.string "kp_name"
    t.integer "kp_year_joined"
    t.string "kp_role_chairman"
    t.string "kp_role_director"
    t.string "kp_role_investmentmanager"
    t.string "kp_role_title"
    t.text "kp_bio"
    t.integer "kp_shares_owned"
    t.decimal "share_price_eoy"
    t.decimal "kp_share_value"
    t.string "kp_image_saved"
    t.string "kp_image_file_name"
    t.integer "lic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lic_id"], name: "index_key_people_on_lic_id"
  end

  create_table "lics", force: :cascade do |t|
    t.string "ticker"
    t.string "name"
    t.bigint "market_cap"
    t.integer "listing_year"
    t.date "listing_date"
    t.integer "yrs_operating"
    t.string "investment_focus"
    t.string "portfolio_bias"
    t.string "benchmark"
    t.string "management_structure"
    t.string "investment_manager"
    t.string "management_fee"
    t.string "performance_fee"
    t.text "objective"
    t.string "logo_filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.decimal "calculated_mer"
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

  create_table "number_shares", force: :cascade do |t|
    t.string "lic_ticker"
    t.string "lic_name"
    t.integer "year"
    t.bigint "number_shares"
    t.integer "lic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "performances", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "portfolio_holdings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "lic_ticker"
    t.string "lic_name"
    t.integer "year"
    t.string "ordering_method"
    t.string "holding_type"
    t.string "holding_name"
    t.decimal "weight"
    t.string "sector"
    t.string "industry"
    t.string "size"
    t.string "headquartered"
    t.integer "lic_id"
  end

  create_table "share_price_histories", force: :cascade do |t|
    t.string "lic_ticker"
    t.string "lic_name"
    t.integer "lic_id"
    t.date "date"
    t.decimal "share_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "share_price_summaries", force: :cascade do |t|
    t.string "lic_ticker"
    t.string "lic_name"
    t.integer "year"
    t.decimal "sp_opening"
    t.decimal "sp_closing"
    t.decimal "sp_average"
    t.integer "lic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.integer "year"
    t.index ["lic_id"], name: "index_share_price_vs_nta_on_lic_id"
  end

  create_table "size_net_assets", force: :cascade do |t|
    t.string "lic_ticker"
    t.string "lic_name"
    t.integer "year"
    t.bigint "size_net_assets"
    t.integer "lic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lic_id"], name: "index_size_net_assets_on_lic_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "key_people", "lics"
  add_foreign_key "share_price_vs_nta", "lics"
  add_foreign_key "size_net_assets", "lics"
end
