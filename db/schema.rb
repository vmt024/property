# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110109014531) do

  create_table "categories", :force => true do |t|
    t.string   "description",   :limit => 50, :null => false
    t.integer  "parent_id"
    t.string   "category_type", :limit => 10, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "property_accounts", :force => true do |t|
    t.integer  "user_id",                          :null => false
    t.string   "address_1",          :limit => 50
    t.string   "address_2",          :limit => 50
    t.string   "address_3",          :limit => 50
    t.string   "address_4",          :limit => 50
    t.string   "post_code",          :limit => 4
    t.string   "property_type",      :limit => 15
    t.integer  "number_of_bedrooms"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", :force => true do |t|
    t.integer  "property_account_id"
    t.date     "date"
    t.string   "description",         :limit => 100
    t.integer  "category_id"
    t.decimal  "amount",                             :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",       :limit => 20
    t.string   "email",      :limit => 50, :null => false
    t.string   "password",   :limit => 64, :null => false
    t.string   "salt",       :limit => 64, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
