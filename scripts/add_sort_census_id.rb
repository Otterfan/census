Text.find_each do |text|
  census_id_parts = text.census_id.split('.')
  major = census_id_parts[0].to_s.rjust(2,"0")
  minor = census_id_parts[1].to_s.rjust(6,"0")
  text.sort_census_id = major + minor
  text.sort_census_id
  text.save
end
