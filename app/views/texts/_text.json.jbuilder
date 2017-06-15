json.extract! text, :id, :title, :greek_title, :date, :publisher, :location, :language, :note, :original, :census_id, :created_at, :updated_at
json.url text_url(text, format: :json)
