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

ActiveRecord::Schema.define(version: 20_140_212_101_135) do

  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'
  enable_extension 'hstore'

  create_table 'auth_tokens', force: true do |t|
    t.string 'value'
    t.string 'status'
    t.integer 'user_id'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'auth_tokens', ['user_id'], name: 'index_auth_tokens_on_user_id', using: :btree

  create_table 'credits', force: true do |t|
    t.string 'master_transaction_id'
    t.float 'amount'
    t.integer 'user_id'
    t.string 'status'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string 'uid'
    t.string 'currency'
  end

  add_index 'credits', ['user_id'], name: 'index_credits_on_user_id', using: :btree

  create_table 'tokens', force: true do |t|
    t.string 'value'
    t.string 'transaction_id'
    t.datetime 'expiry_date'
    t.string 'status'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'transactions', force: true do |t|
    t.string 'uid'
    t.float 'amount'
    t.string 'status'
    t.datetime 'expiry_date'
    t.string 'sender_email'
    t.string 'recipient_email'
    t.string 'currency'
    t.text 'references'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.hstore 'break_down'
  end

  create_table 'users', force: true do |t|
    t.string 'email'
    t.string 'category'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

end
