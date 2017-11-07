Text.where('original LIKE ?', '\\\\*%').each do |text|
  text.seen_in_person = true
  puts text.census_id
  text.save
end