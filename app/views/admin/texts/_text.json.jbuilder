json.extract! text, :id, :title, :greek_title, :date, :publisher, :place_of_publication, :language, :note, :original, :census_id, :created_at, :updated_at
json.url text_url(text, format: :json)
