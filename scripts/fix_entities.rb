Text.where('publisher LIKE ?', '%&#46%').each do |text|
  text.publisher.gsub!('&#46','.')
  puts text.publisher
  text.save
end

Text.where('original LIKE ?', '%&#46%').each do |text|
  text.original.gsub!('&#46','.')
  puts text.original
  text.save
end