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

ActiveRecord::Schema.define(version: 20170615053342) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "component_citations", force: :cascade do |t|
    t.bigint "component_id"
    t.bigint "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "role_id"
    t.index ["component_id"], name: "index_component_citations_on_component_id"
    t.index ["person_id"], name: "index_component_citations_on_person_id"
    t.index ["role_id"], name: "index_component_citations_on_role_id"
  end

  create_table "components", force: :cascade do |t|
    t.text "title"
    t.text "pages"
    t.integer "ordinal"
    t.bigint "text_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["text_id"], name: "index_components_on_text_id"
  end

  create_table "languages", force: :cascade do |t|
    t.text "name"
    t.text "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ordinal"
    t.index ["ordinal"], name: "index_languages_on_ordinal", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.text "full_name"
    t.text "greek_full_name"
    t.text "fist_name"
    t.text "last_name"
    t.text "birth"
    t.text "death"
    t.text "greek_first_name"
    t.text "greek_last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "standard_identifier_types", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "standard_identifiers", force: :cascade do |t|
    t.bigint "standard_identifier_type_id"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["standard_identifier_type_id"], name: "index_standard_identifiers_on_standard_identifier_type_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.text "name"
    t.integer "ordinal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "code"
  end

  create_table "text_citations", force: :cascade do |t|
    t.bigint "text_id"
    t.text "name"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_text_citations_on_role_id"
    t.index ["text_id"], name: "index_text_citations_on_text_id"
  end

  create_table "texts", force: :cascade do |t|
    t.text "title"
    t.text "greek_title"
    t.text "date"
    t.date "sort_date"
    t.text "publisher"
    t.text "location"
    t.bigint "language_id"
    t.text "note"
    t.text "original"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "census_id"
    t.bigint "topic_author_id"
    t.text "pages"
    t.bigint "status_id"
    t.index ["language_id"], name: "index_texts_on_language_id"
    t.index ["status_id"], name: "index_texts_on_status_id"
    t.index ["topic_author_id"], name: "index_texts_on_topic_author_id"
  end

  add_foreign_key "component_citations", "components"
  add_foreign_key "component_citations", "people"
  add_foreign_key "component_citations", "roles"
  add_foreign_key "components", "texts"
  add_foreign_key "standard_identifiers", "standard_identifier_types"
  add_foreign_key "text_citations", "roles"
  add_foreign_key "text_citations", "texts"
  add_foreign_key "texts", "languages"
  add_foreign_key "texts", "people", column: "topic_author_id"
  add_foreign_key "texts", "statuses"
end
