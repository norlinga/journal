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

ActiveRecord::Schema[8.0].define(version: 2025_03_12_182033) do
  create_table "batches", force: :cascade do |t|
    t.string "status", default: "pending", null: false
    t.datetime "processed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_batches_on_status"
  end

  create_table "journal_entries", force: :cascade do |t|
    t.integer "batch_id", null: false
    t.integer "order_id", null: false
    t.string "account_type", null: false
    t.integer "amount", null: false
    t.string "entry_type", null: false
    t.boolean "balanced", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["balanced"], name: "index_journal_entries_on_balanced"
    t.index ["batch_id"], name: "index_journal_entries_on_batch_id"
    t.index ["entry_type"], name: "index_journal_entries_on_entry_type"
    t.index ["order_id"], name: "index_journal_entries_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "batch_id", null: false
    t.integer "external_order_id"
    t.datetime "ordered_at"
    t.string "item_type"
    t.decimal "price_per_item", precision: 10, scale: 2
    t.integer "quantity"
    t.decimal "shipping", precision: 10, scale: 2
    t.decimal "tax_rate", precision: 5, scale: 3
    t.string "payment_1_id"
    t.decimal "payment_1_amount", precision: 10, scale: 2
    t.string "payment_2_id"
    t.decimal "payment_2_amount", precision: 10, scale: 2
    t.text "raw_data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_orders_on_batch_id"
  end

  add_foreign_key "journal_entries", "batches"
  add_foreign_key "journal_entries", "orders"
  add_foreign_key "orders", "batches"
end
