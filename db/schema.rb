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

ActiveRecord::Schema.define(version: 2021_06_29_211448) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blazer_audits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.bigint "creator_id"
    t.bigint "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "query_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.bigint "creator_id"
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "value"
    t.bigint "user_id"
    t.bigint "text_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["text_id"], name: "index_comments_on_text_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "component_citations", force: :cascade do |t|
    t.bigint "component_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "role"
    t.bigint "from_language_id"
    t.bigint "to_language_id"
    t.string "first_name"
    t.string "last_name"
    t.text "controlled_name"
    t.string "sort_name"
    t.index ["component_id"], name: "index_component_citations_on_component_id"
    t.index ["from_language_id"], name: "index_component_citations_on_from_language_id"
    t.index ["sort_name"], name: "index_component_citations_on_sort_name"
    t.index ["to_language_id"], name: "index_component_citations_on_to_language_id"
  end

  create_table "components", force: :cascade do |t|
    t.text "title"
    t.text "pages"
    t.integer "ordinal"
    t.bigint "text_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "genre"
    t.string "text_type"
    t.text "note"
    t.boolean "is_bilingual"
    t.text "collection"
    t.text "section"
    t.text "subsection"
    t.integer "sort_pages"
    t.index ["sort_pages"], name: "index_components_on_sort_pages"
    t.index ["text_id"], name: "index_components_on_text_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "al3_code"
    t.string "num_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["al3_code"], name: "index_countries_on_al3_code"
    t.index ["name"], name: "index_countries_on_name"
    t.index ["num_code"], name: "index_countries_on_num_code"
  end

  create_table "cross_references", force: :cascade do |t|
    t.string "census_id"
    t.bigint "text_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["text_id"], name: "index_cross_references_on_text_id"
  end

  create_table "journals", force: :cascade do |t|
    t.text "title"
    t.string "issn"
    t.text "indexed_range"
    t.bigint "place_id"
    t.text "sort_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sponsoring_organization"
    t.string "eissn"
    t.string "issn_1"
    t.string "issn_2"
    t.string "issn_3"
    t.string "url"
    t.string "first_published"
    t.text "notes"
    t.index ["place_id"], name: "index_journals_on_place_id"
  end

  create_table "languages", force: :cascade do |t|
    t.text "name"
    t.text "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ordinal"
    t.index ["ordinal"], name: "index_languages_on_ordinal"
  end

  create_table "other_text_languages", force: :cascade do |t|
    t.bigint "language_id", null: false
    t.bigint "text_id", null: false
    t.index ["language_id", "text_id"], name: "index_other_text_languages_on_language_id_and_text_id"
    t.index ["text_id", "language_id"], name: "index_other_text_languages_on_text_id_and_language_id"
  end

  create_table "people", force: :cascade do |t|
    t.text "full_name"
    t.text "greek_full_name"
    t.text "first_name"
    t.text "last_name"
    t.text "birth"
    t.text "death"
    t.text "greek_first_name"
    t.text "greek_last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "topic_flag"
    t.string "domicile"
    t.string "alternate_name"
    t.string "viaf"
    t.string "loc"
    t.string "greek_authority"
    t.string "loc_name"
    t.index ["topic_flag"], name: "index_people_on_topic_flag"
  end

  create_table "places", force: :cascade do |t|
    t.string "name"
    t.bigint "country_id"
    t.string "latitude"
    t.string "longitude"
    t.string "subdivision"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_places_on_country_id"
  end

  create_table "publication_places", force: :cascade do |t|
    t.bigint "place_id", null: false
    t.bigint "text_id", null: false
    t.boolean "primary"
    t.index ["place_id", "text_id"], name: "index_publication_places_on_place_id_and_text_id"
    t.index ["text_id", "place_id"], name: "index_publication_places_on_text_id_and_place_id"
  end

  create_table "recent_searches", force: :cascade do |t|
    t.text "parameters"
    t.text "session_id"
    t.text "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sections", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "standard_numbers", force: :cascade do |t|
    t.string "value"
    t.bigint "text_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "numtype"
    t.index ["text_id"], name: "index_standard_numbers_on_text_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.text "name"
    t.integer "ordinal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "code"
    t.string "display"
  end

  create_table "text_citations", force: :cascade do |t|
    t.bigint "text_id"
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.bigint "from_language_id"
    t.bigint "to_language_id"
    t.text "source_edition"
    t.string "first_name"
    t.string "last_name"
    t.integer "ordinal", default: 0
    t.text "controlled_name"
    t.string "sort_name"
    t.index ["from_language_id"], name: "index_text_citations_on_from_language_id"
    t.index ["ordinal"], name: "index_text_citations_on_ordinal"
    t.index ["sort_name"], name: "index_text_citations_on_sort_name"
    t.index ["text_id"], name: "index_text_citations_on_text_id"
    t.index ["to_language_id"], name: "index_text_citations_on_to_language_id"
  end

  create_table "texts", force: :cascade do |t|
    t.text "title"
    t.text "source"
    t.text "date"
    t.date "sort_date"
    t.text "publisher"
    t.text "place_of_publication"
    t.bigint "language_id"
    t.text "note"
    t.text "original"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "census_id"
    t.bigint "topic_author_id"
    t.text "page_span"
    t.bigint "status_id"
    t.string "issue_number"
    t.string "genre"
    t.string "journal_title"
    t.string "series"
    t.string "page_count"
    t.string "text_type"
    t.boolean "is_bilingual"
    t.bigint "section_id"
    t.string "original_greek_title"
    t.string "original_greek_place_of_publication"
    t.string "original_greek_publisher"
    t.string "original_greek_date"
    t.string "original_greek_edition"
    t.bigint "country_id"
    t.boolean "illustrations_noted"
    t.text "url"
    t.text "sponsoring_organization"
    t.text "special_location_of_item"
    t.text "special_source_of_info"
    t.bigint "journal_id"
    t.string "issue_volume"
    t.string "issue_season_month"
    t.bigint "volume_id"
    t.string "issue_editor"
    t.string "issue_title"
    t.text "abstract"
    t.boolean "seen_in_person"
    t.text "authors_name_from_source"
    t.text "editorial_annotation"
    t.text "physical_description"
    t.string "original_greek_collection"
    t.string "material_type"
    t.string "dai"
    t.integer "sort_id"
    t.string "collection"
    t.text "sort_census_id"
    t.boolean "is_special_issue"
    t.boolean "is_hidden", default: false
    t.boolean "is_collected_volume"
    t.integer "sort_page_span"
    t.date "accessed_on"
    t.string "proquest_num"
    t.text "sort_title"
    t.text "sort_author"
    t.index ["country_id"], name: "index_texts_on_country_id"
    t.index ["journal_id"], name: "index_texts_on_journal_id"
    t.index ["language_id"], name: "index_texts_on_language_id"
    t.index ["original_greek_title"], name: "index_texts_on_original_greek_title"
    t.index ["section_id"], name: "index_texts_on_section_id"
    t.index ["sort_author"], name: "index_texts_on_sort_author"
    t.index ["sort_id"], name: "index_texts_on_sort_id"
    t.index ["sort_page_span"], name: "index_texts_on_sort_page_span"
    t.index ["sort_title"], name: "index_texts_on_sort_title"
    t.index ["status_id"], name: "index_texts_on_status_id"
    t.index ["topic_author_id"], name: "index_texts_on_topic_author_id"
    t.index ["volume_id"], name: "index_texts_on_volume_id"
  end

  create_table "urls", force: :cascade do |t|
    t.text "value"
    t.date "accessed_on"
    t.text "wayback"
    t.bigint "text_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["text_id", "value"], name: "index_urls_on_text_id_and_value", unique: true
    t.index ["text_id"], name: "index_urls_on_text_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_type", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "volume_citations", force: :cascade do |t|
    t.bigint "volume_id"
    t.string "last_name"
    t.string "first_name"
    t.string "role"
    t.bigint "from_language_id_id"
    t.bigint "to_language_id_id"
    t.text "source_edition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "name"
    t.text "controlled_name"
    t.string "sort_name"
    t.index ["from_language_id_id"], name: "index_volume_citations_on_from_language_id_id"
    t.index ["sort_name"], name: "index_volume_citations_on_sort_name"
    t.index ["to_language_id_id"], name: "index_volume_citations_on_to_language_id_id"
    t.index ["volume_id"], name: "index_volume_citations_on_volume_id"
  end

  create_table "volumes", force: :cascade do |t|
    t.text "title"
    t.text "author"
    t.string "date"
    t.text "sort_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "editor"
    t.string "conference_title"
    t.string "conference_place"
    t.string "conference_date"
  end

  add_foreign_key "comments", "texts"
  add_foreign_key "comments", "users"
  add_foreign_key "component_citations", "components", on_delete: :cascade
  add_foreign_key "component_citations", "languages", column: "from_language_id"
  add_foreign_key "component_citations", "languages", column: "to_language_id"
  add_foreign_key "components", "texts"
  add_foreign_key "cross_references", "texts"
  add_foreign_key "places", "countries"
  add_foreign_key "standard_numbers", "texts"
  add_foreign_key "text_citations", "languages", column: "from_language_id"
  add_foreign_key "text_citations", "languages", column: "to_language_id"
  add_foreign_key "text_citations", "texts"
  add_foreign_key "texts", "countries", on_delete: :nullify
  add_foreign_key "texts", "journals", on_delete: :nullify
  add_foreign_key "texts", "languages", on_delete: :nullify
  add_foreign_key "texts", "people", column: "topic_author_id"
  add_foreign_key "texts", "sections", on_delete: :nullify
  add_foreign_key "texts", "statuses", on_delete: :nullify
  add_foreign_key "texts", "volumes", on_delete: :nullify
  add_foreign_key "volume_citations", "languages", column: "from_language_id_id"
  add_foreign_key "volume_citations", "languages", column: "to_language_id_id"
  add_foreign_key "volume_citations", "volumes"
end
