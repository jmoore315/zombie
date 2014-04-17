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

ActiveRecord::Schema.define(version: 20130724211825) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.boolean  "active"
    t.string   "role"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "telephone"
    t.string   "nickname"
    t.string   "uuid"
    t.string   "email"
    t.datetime "deactivated_at"
    t.string   "first_image_url"
  end

  create_table "bookmarks", force: true do |t|
    t.integer  "account_id"
    t.integer  "bookmarkable_id"
    t.string   "bookmarkable_type"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bookmarks", ["account_id"], name: "index_bookmarks_on_account_id", using: :btree

  create_table "images", force: true do |t|
    t.string   "image"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "filename"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "encoded_filename"
    t.string   "imageable_uuid"
  end

  add_index "images", ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type", using: :btree

  create_table "listings", force: true do |t|
    t.integer  "listable_id"
    t.boolean  "active"
    t.boolean  "banned"
    t.datetime "opened_at"
    t.datetime "closed_at"
    t.datetime "will_close_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "listable_type"
    t.integer  "school_id"
    t.string   "property_type"
    t.boolean  "deleted"
  end

  create_table "marketplace_items", force: true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.text     "description"
    t.string   "category"
    t.string   "subcategory"
    t.boolean  "deleted"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.boolean  "active"
    t.integer  "marketplace_category_id"
    t.string   "uuid"
    t.string   "condition"
    t.datetime "list_from"
    t.datetime "list_until"
    t.integer  "price"
    t.string   "first_image_url"
  end

  add_index "marketplace_items", ["account_id"], name: "index_classifieds_on_account_id", using: :btree

  create_table "messages", force: true do |t|
    t.text     "content"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "account_id"
    t.string   "sender_email"
    t.string   "sender_name"
    t.string   "sender_telephone"
    t.integer  "messageable_id"
    t.string   "messageable_type"
    t.string   "school_code"
  end

  create_table "properties", force: true do |t|
    t.text     "description"
    t.string   "property_type"
    t.boolean  "pets_allowed"
    t.boolean  "water_included"
    t.boolean  "air_conditioning"
    t.boolean  "electric_included"
    t.boolean  "active"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "parking"
    t.boolean  "television"
    t.boolean  "internet"
    t.integer  "account_id"
    t.boolean  "deleted"
    t.boolean  "gas_included"
    t.boolean  "smoking"
    t.boolean  "furnished"
    t.string   "uuid"
    t.datetime "owner_fblike_time"
    t.boolean  "graduate_only"
    t.integer  "school_id"
    t.boolean  "central_air"
    t.string   "first_image_url"
  end

  add_index "properties", ["account_id"], name: "index_properties_on_account_id", using: :btree

  create_table "property_schools", force: true do |t|
    t.integer  "property_id"
    t.integer  "school_id"
    t.float    "distance"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roommate_listings", force: true do |t|
    t.string   "gender"
    t.integer  "grad_year"
    t.integer  "ideal_rent"
    t.date     "occupancy_date"
    t.string   "fb_link"
    t.string   "telephone"
    t.string   "pref_gender"
    t.string   "pref_smoking"
    t.string   "pref_pets"
    t.string   "pref_cleanliness"
    t.string   "pref_social"
    t.integer  "pref_age"
    t.integer  "age"
    t.string   "cleanliness"
    t.string   "social"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.boolean  "active"
    t.string   "uuid"
    t.string   "title"
    t.text     "description"
    t.boolean  "deleted"
    t.string   "first_image_url"
  end

  create_table "schools", force: true do |t|
    t.string   "name"
    t.string   "nickname"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
  end

  create_table "unit_classes", force: true do |t|
    t.integer  "bedrooms"
    t.integer  "bathrooms"
    t.integer  "property_id"
    t.boolean  "active"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "roommates"
    t.integer  "size"
    t.datetime "lease_from"
    t.datetime "lease_until"
    t.datetime "list_from"
    t.datetime "list_until"
    t.integer  "price"
    t.boolean  "deleted"
    t.boolean  "graduate_only"
    t.string   "property_type"
  end

  add_index "unit_classes", ["property_id"], name: "index_unit_classes_on_property_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                      default: "", null: false
    t.string   "encrypted_password",         default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "deleted"
    t.integer  "account_id"
    t.boolean  "admin"
    t.boolean  "notify_listings"
    t.boolean  "notify_newsletter"
    t.boolean  "notify_major_announcements"
    t.boolean  "active"
    t.datetime "deactivated_at"
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
