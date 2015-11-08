<<<<<<< HEAD
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

ActiveRecord::Schema.define(version: 20141019140504) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deal_orders", force: true do |t|
    t.integer  "order_id"
    t.integer  "deal_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ticket_number"
    t.boolean  "cancelled",     default: false
  end

  create_table "deals", force: true do |t|
    t.string   "name"
    t.integer  "deal_no"
    t.string   "category"
    t.text     "contents"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "details", force: true do |t|
    t.string   "name"
    t.string   "city"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.datetime "today_date"
  end

  create_table "meal_orders", force: true do |t|
    t.integer  "meal_id"
    t.integer  "order_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category",      default: "full"
    t.integer  "ticket_number"
    t.boolean  "cancelled",     default: false
  end

  create_table "meals", force: true do |t|
    t.string   "name_english"
    t.string   "name_urdu",        default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category_english", default: ""
    t.string   "category_urdu"
    t.integer  "category_number"
    t.integer  "price_full"
    t.integer  "price_half"
  end

  create_table "orders", force: true do |t|
    t.integer  "table_id"
    t.string   "receiptno"
    t.boolean  "status",          default: true
    t.integer  "total"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "store_closed",    default: false
    t.boolean  "category"
    t.boolean  "cash_received",   default: false
    t.integer  "change",          default: 0
    t.integer  "amount_received", default: 0
    t.string   "work_date"
  end

  create_table "reports", force: true do |t|
    t.string   "file_path"
    t.string   "file_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tables", force: true do |t|
    t.integer  "nmr"
    t.integer  "seats"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "taken",      default: false
  end

  create_table "users", force: true do |t|
    t.string   "user_name"
    t.string   "password_hash"
    t.string   "password_salt"
    t.boolean  "admin",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
  end

end
=======
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

ActiveRecord::Schema.define(version: 20141019140504) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deal_orders", force: true do |t|
    t.integer  "order_id"
    t.integer  "deal_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ticket_number"
    t.boolean  "cancelled",     default: false
  end

  create_table "deals", force: true do |t|
    t.string   "name"
    t.integer  "deal_no"
    t.string   "category"
    t.text     "contents"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "details", force: true do |t|
    t.string   "name"
    t.string   "city"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.datetime "today_date"
  end

  create_table "meal_orders", force: true do |t|
    t.integer  "meal_id"
    t.integer  "order_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category",      default: "full"
    t.integer  "ticket_number"
    t.boolean  "cancelled",     default: false
  end

  create_table "meals", force: true do |t|
    t.string   "name_english"
    t.string   "name_urdu",        default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category_english", default: ""
    t.string   "category_urdu"
    t.integer  "category_number"
    t.integer  "price_full"
    t.integer  "price_half"
  end

  create_table "orders", force: true do |t|
    t.integer  "table_id"
    t.string   "receiptno"
    t.boolean  "status",          default: true
    t.integer  "total"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "store_closed",    default: false
    t.boolean  "category"
    t.boolean  "cash_received",   default: false
    t.integer  "change",          default: 0
    t.integer  "amount_received", default: 0
    t.string   "work_date"
  end

  create_table "reports", force: true do |t|
    t.string   "file_path"
    t.string   "file_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tables", force: true do |t|
    t.integer  "nmr"
    t.integer  "seats"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "taken",      default: false
  end

  create_table "users", force: true do |t|
    t.string   "user_name"
    t.string   "password_hash"
    t.string   "password_salt"
    t.boolean  "admin",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
  end

end
>>>>>>> 7b65526ebc566b406761db5db874edfff6dcd787
