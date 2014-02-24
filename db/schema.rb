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

ActiveRecord::Schema.define(version: 20140220063423) do

  create_table "qwyz_items", force: true do |t|
    t.integer  "qwyz_id"
    t.string   "description"
    t.string   "image"
    t.integer  "item_type",   default: 100
    t.integer  "status",      default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "qwyz_items", ["qwyz_id"], name: "index_qwyz_items_on_qwyz_id"

  create_table "qwyzs", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "question"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "qwyzs", ["user_id"], name: "index_qwyzs_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.boolean  "admin",                     default: false
    t.integer  "status",                    default: 1
    t.string   "remember_token"
    t.string   "activation_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_token_date"
  end

  add_index "users", ["activation_token"], name: "index_users_on_activation_token"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["name"], name: "index_users_on_name", unique: true
  add_index "users", ["password_reset_token"], name: "index_users_on_password_reset_token"
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

  create_table "votes", force: true do |t|
    t.integer  "qwyz_id"
    t.integer  "left_item_id"
    t.integer  "right_item_id"
    t.integer  "chosen_item_id"
    t.integer  "voter_user_id"
    t.string   "voter_ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["left_item_id"], name: "index_votes_on_left_item_id"
  add_index "votes", ["qwyz_id"], name: "index_votes_on_qwyz_id"
  add_index "votes", ["right_item_id"], name: "index_votes_on_right_item_id"
  add_index "votes", ["voter_user_id"], name: "index_votes_on_voter_user_id"

end
