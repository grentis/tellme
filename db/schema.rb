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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130418221641) do

  create_table "clients", :force => true do |t|
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "name",         :null => false
    t.text     "address"
    t.string   "iva"
    t.string   "cf"
    t.string   "payment_type"
    t.string   "bank"
    t.string   "abi"
    t.string   "cab"
    t.decimal  "hourly_cost"
    t.text     "note"
  end

  create_table "invoices", :force => true do |t|
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "client_id",                   :null => false
    t.string   "number",                      :null => false
    t.date     "date",                        :null => false
    t.decimal  "amount",     :default => 0.0, :null => false
    t.text     "note"
  end

  create_table "payments", :force => true do |t|
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "invoice_id",                    :null => false
    t.decimal  "value",      :default => 0.0,   :null => false
    t.integer  "year",                          :null => false
    t.integer  "month",                         :null => false
    t.boolean  "paid",       :default => false, :null => false
    t.text     "note"
  end

end
