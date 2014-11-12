# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141111170515) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abc_curve_reports", force: true do |t|
    t.integer  "store_id"
    t.string   "reference"
    t.string   "name"
    t.integer  "quantity"
    t.float    "price"
    t.float    "total_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "abc_curve_reports", ["store_id"], name: "index_abc_curve_reports_on_store_id", using: :btree

  create_table "monthly_reports", force: true do |t|
    t.date     "reference_date"
    t.integer  "orders_count"
    t.float    "orders_yield"
    t.float    "average_ticket"
    t.float    "average_itens"
    t.integer  "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pageviews"
    t.integer  "visits"
    t.integer  "unique_users"
    t.float    "conversion_tax"
  end

  add_index "monthly_reports", ["store_id"], name: "index_monthly_reports_on_store_id", using: :btree

  create_table "order_items", force: true do |t|
    t.integer  "order_id"
    t.integer  "quantity"
    t.string   "reference"
    t.string   "name"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id", using: :btree

  create_table "orders", force: true do |t|
    t.string   "code"
    t.date     "reference_date"
    t.integer  "store_id"
    t.float    "total"
    t.string   "reference_state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["store_id"], name: "index_orders_on_store_id", using: :btree

  create_table "state_reports", force: true do |t|
    t.string   "state"
    t.integer  "orders_count"
    t.float    "orders_yield"
    t.float    "average_ticket"
    t.float    "average_itens"
    t.integer  "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "state_reports", ["store_id"], name: "index_state_reports_on_store_id", using: :btree

  create_table "stores", force: true do |t|
    t.string   "name"
    t.string   "api_url"
    t.string   "user"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "last_page",     default: 1
    t.integer  "last_position", default: 0
    t.string   "token"
    t.string   "ga_token"
  end

end
