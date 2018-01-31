TextCitation.where('name NOT LIKE ?', '%,%').each do |text|
  puts TextCitation.name
end