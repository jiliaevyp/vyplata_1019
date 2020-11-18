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

ActiveRecord::Schema.define(version: 20190826181951) do

  create_table "admins", force: :cascade do |t|
    t.integer  "personal_id"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "password"
    t.string   "password_confirmation"
    t.integer  "glob_admin",            default: 0
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "admins", ["personal_id"], name: "index_admins_on_personal_id"

  create_table "comments", force: :cascade do |t|
    t.integer  "mond_id"
    t.integer  "personal_id"
    t.integer  "tabel_id"
    t.string   "title"
    t.string   "forname"
    t.string   "fornametwo"
    t.string   "email"
    t.integer  "commenter_id"
    t.string   "commenter_title"
    t.text     "body"
    t.integer  "plunus",          default: 0
    t.date     "data"
    t.integer  "num_monat"
    t.string   "yahre"
    t.integer  "close_update"
    t.string   "reservstring"
    t.integer  "reservint"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["mond_id"], name: "index_comments_on_mond_id"
  add_index "comments", ["personal_id"], name: "index_comments_on_personal_id"
  add_index "comments", ["tabel_id"], name: "index_comments_on_tabel_id"

  create_table "levels", force: :cascade do |t|
    t.integer  "admin_id"
    t.string   "access_controller"
    t.string   "access_action"
    t.string   "format"
    t.string   "format_next"
    t.integer  "access_all_otdel"
    t.integer  "access_full"
    t.integer  "access_index"
    t.integer  "access_show"
    t.integer  "access_edit"
    t.integer  "access_new"
    t.integer  "access_del"
    t.integer  "access_print"
    t.integer  "access_email"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "levels", ["admin_id"], name: "index_levels_on_admin_id"

  create_table "monds", force: :cascade do |t|
    t.string   "yahre"
    t.integer  "num_monat"
    t.integer  "tag",                                         default: 21
    t.integer  "hour",                                        default: 168
    t.decimal  "kfoberhour",          precision: 2, scale: 1, default: 2.0
    t.integer  "kfnalog",                                     default: 13
    t.integer  "procentsocial",                               default: 24
    t.integer  "block_mond",                                  default: 0
    t.integer  "block_personal",                              default: 0
    t.integer  "block_real_personal",                         default: 0
    t.integer  "block_comment",                               default: 0
    t.integer  "block_timetabel",                             default: 0
    t.integer  "block_tabel",                                 default: 0
    t.integer  "block_buchtabel",                             default: 0
    t.integer  "close_update",                                default: 0
    t.string   "reservstring"
    t.integer  "reservint"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personals", force: :cascade do |t|
    t.string   "title"
    t.string   "forname"
    t.string   "fornametwo"
    t.string   "image_url"
    t.string   "kadr"
    t.integer  "num_otdel"
    t.string   "otdel"
    t.integer  "real"
    t.integer  "tarifhour"
    t.date     "begdata"
    t.date     "enddata"
    t.string   "bilding"
    t.date     "borndata"
    t.string   "familie"
    t.string   "kinder"
    t.string   "haus"
    t.string   "auto"
    t.string   "address"
    t.string   "realaddress"
    t.string   "tel"
    t.string   "email",              default: ""
    t.string   "werte"
    t.text     "information"
    t.integer  "close_update"
    t.string   "reservstring"
    t.integer  "reservint"
    t.integer  "personal_admin",     default: 0
    t.string   "encrypted_password", default: "", null: false
    t.string   "password_digest"
    t.string   "password",           default: ""
    t.string   "open_password",      default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tabels", force: :cascade do |t|
    t.integer  "personal_id"
    t.integer  "mond_id"
    t.string   "title"
    t.string   "forname"
    t.string   "fornametwo"
    t.string   "kadr"
    t.string   "email"
    t.integer  "num_otdel"
    t.integer  "tarifhour"
    t.integer  "num_monat"
    t.string   "yahre"
    t.integer  "tag"
    t.integer  "hour"
    t.integer  "kfoberhour"
    t.integer  "kfnalog"
    t.integer  "procentsocial"
    t.integer  "tagemach",                                   default: 21
    t.integer  "hourmach",                                   default: 168
    t.integer  "oberhour",                                   default: 0
    t.integer  "krankentage",                                default: 0
    t.integer  "urlaub",                                     default: 0
    t.integer  "reisetage",                                  default: 0
    t.decimal  "hourgeld"
    t.decimal  "reisegeld"
    t.decimal  "oberhourgeld"
    t.decimal  "oklad"
    t.decimal  "proc_bonus"
    t.integer  "bonus"
    t.integer  "nadbavka"
    t.decimal  "summa"
    t.integer  "krankengeld"
    t.integer  "urlaubgeld"
    t.integer  "minus",                                      default: 0
    t.string   "textminus"
    t.decimal  "gehalt"
    t.decimal  "nalog",              precision: 8, scale: 2
    t.decimal  "naruki",             precision: 8, scale: 2
    t.decimal  "social",             precision: 8, scale: 2
    t.decimal  "vsego",              precision: 8, scale: 2
    t.integer  "close_update_tabel"
    t.string   "reservstring"
    t.integer  "reservint"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
  end

  add_index "tabels", ["mond_id"], name: "index_tabels_on_mond_id"
  add_index "tabels", ["personal_id"], name: "index_tabels_on_personal_id"

end
