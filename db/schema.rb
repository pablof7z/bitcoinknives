# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_13_124603) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bitcoin_price_changes", force: :cascade do |t|
    t.string "base_currency"
    t.string "period"
    t.decimal "open_price"
    t.decimal "close_price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "change_percentage"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "amount"
    t.string "currency", default: "BTC"
    t.string "status"
    t.string "btcpay_invoice_id"
    t.string "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "logs", force: :cascade do |t|
    t.string "message"
    t.string "backtrace"
    t.string "severity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "rules", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.float "change_percentage"
    t.string "change_period", default: "24 hours"
    t.string "formula"
    t.integer "max_sats_per_trade", default: 1000000
    t.integer "max_sats_per_period", default: 2500000
    t.boolean "enabled", default: true
    t.string "exchange_name"
    t.string "exchange_api_key"
    t.string "exchange_api_secret"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.string "base_currency", default: "USD"
    t.string "max_sats_per_period_length", default: "1 week"
    t.string "exchange_api_passphrase"
    t.string "mayer_multiple"
    t.decimal "mayer_multiple_value"
    t.boolean "trade_notification", default: true
    t.index ["slug"], name: "index_rules_on_slug", unique: true
    t.index ["user_id"], name: "index_rules_on_user_id"
  end

  create_table "trades", force: :cascade do |t|
    t.bigint "rule_id", null: false
    t.decimal "change_percentage"
    t.decimal "amount"
    t.decimal "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "executed_at"
    t.string "tx_info"
    t.string "tx_id"
    t.string "tx_status"
    t.index ["rule_id"], name: "index_trades_on_rule_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "upgraded", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "invoices", "users"
  add_foreign_key "rules", "users"
  add_foreign_key "trades", "rules"
end
