# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 4) do

  create_table "items", :force => true do |t|
    t.string   "type",        :default => "", :null => false
    t.string   "title",       :default => "", :null => false
    t.text     "description"
    t.datetime "created",                     :null => false
    t.datetime "date_back",                   :null => false
    t.integer  "held_by",                     :null => false
    t.integer  "owner_id",                    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "address"
    t.string   "city"
    t.string   "postalcode",                              :default => "", :null => false
    t.integer  "latitude",                                                :null => false
    t.integer  "longitude",                                               :null => false
    t.string   "cellphone",                 :limit => 10
    t.string   "cellphone_provider"
    t.integer  "region_id",                               :default => 1
  end

end
