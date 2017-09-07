json.extract! person, :id, :full_name, :greek_full_name, :first_name, :last_name, :birth, :death, :greek_first_name, :greek_last_name, :created_at, :updated_at
json.url person_url(person, format: :json)
