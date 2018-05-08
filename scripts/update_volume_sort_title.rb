# remove pesky unicode \u00A0 spaces in titles
Volume.where('title ~ \'\x00A0\'').each do |volume|
  puts "\ntitle: \"#{volume.title}\""
  title = volume.title.gsub(/\u00A0/, " ")
  volume.update(:title => title)
end

# remove colons from sort_title
Volume.where('title LIKE ?', '%:%').each do |volume|
  sort_title = volume.title.sub(/^The +/, '').sub(/^An +/, '').sub(/^A +/, '').sub(/:/, '')
  volume.update(:sort_title => sort_title)
  puts "\noriginal title:     \"#{volume.title}\""
  puts "updated sort_title: \"#{volume.sort_title}\""
end