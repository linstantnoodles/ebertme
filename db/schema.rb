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

ActiveRecord::Schema.define(version: 20161219052213) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "critics", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movies", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "poster_img_url"
  end

  create_table "movies_providers", id: false, force: :cascade do |t|
    t.integer "movie_id",    null: false
    t.integer "provider_id", null: false
    t.index ["movie_id", "provider_id"], name: "index_movies_providers_on_movie_id_and_provider_id", using: :btree
    t.index ["provider_id", "movie_id"], name: "index_movies_providers_on_provider_id_and_movie_id", using: :btree
  end

  create_table "providers", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "rating"
    t.datetime "date"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "critic_id"
    t.integer  "movie_id"
    t.index ["critic_id"], name: "index_reviews_on_critic_id", using: :btree
    t.index ["movie_id"], name: "index_reviews_on_movie_id", using: :btree
  end

  add_foreign_key "reviews", "critics"
  add_foreign_key "reviews", "movies"
end
