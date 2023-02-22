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

ActiveRecord::Schema[7.0].define(version: 2023_02_20_144838) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "inventories", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_inventories_on_product_id"
    t.index ["store_id", "product_id"], name: "index_inventories_on_store_id_and_product_id", unique: true
    t.index ["store_id"], name: "index_inventories_on_store_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.float "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_products_on_name", unique: true
  end

  create_table "sales", force: :cascade do |t|
    t.bigint "store_id"
    t.bigint "product_id"
    t.integer "quantity", default: 1, null: false
    t.jsonb "metadata", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "price"
    t.index ["created_at"], name: "index_sales_on_created_at"
    t.index ["product_id"], name: "index_sales_on_product_id"
    t.index ["store_id"], name: "index_sales_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_stores_on_name", unique: true
  end

  create_table "webhooks", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.jsonb "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "inventories", "products"
  add_foreign_key "inventories", "stores"
  add_foreign_key "sales", "products"
  add_foreign_key "sales", "stores"
end
