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

ActiveRecord::Schema.define(:version => 20120412100348) do

  create_table "groups", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "groups_parties", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "party_id"
  end

  create_table "parties", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "surname"
    t.string   "email"
    t.string   "cell"
    t.string   "type"
    t.string   "gender"
  end

  create_table "party_roles", :force => true do |t|
    t.integer  "party_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "faculty"
  end

  add_index "party_roles", ["party_id"], :name => "index_party_roles_on_party_id"

  create_table "surveys", :force => true do |t|
    t.integer  "party_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "surveys", ["party_id"], :name => "index_surveys_on_party_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
