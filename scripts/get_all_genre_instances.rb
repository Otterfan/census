# get a list of all Text records that have a specific genre value
genres =  Text.pluck(:genre).uniq
genres_sorted = genres.sort { |a,b| a && b ? a <=> b : a ? -1 : 1 }

output = File.open( "genre-outputfile.txt","w" )

genres_sorted.each do |genre|
  if genre == nil
    puts "none\n======="
    output << "none\n=======\n"
  elsif genre == ""
    puts "empty string\n======="
    output << "empty string\n=======\n"
  else
    puts "\"#{genre}\"\n======="
    output << "\"#{genre}\"\n=======\n"
  end

  texts = Text.where(:genre => genre).order(:sort_census_id)

  texts.each do |text|
    puts "#{text.census_id}"
    output << "#{text.census_id}\n"
  end

  puts "\n\n"
  output << "\n\n"
end

output.close
