# Get a list of all Component records that have a specific genre value.
#
# Run this script from a rails console:
# load './scripts/reports/get_all_component_genre_instances.rb'

time_stamp_start = Time.now
time_stamp_file_name = time_stamp_start.strftime('%Y%m%d-%H%M%S')
time_stamp_readable = time_stamp_start.strftime('%B %d %Y %H:%M%p')

site_url = "https://www.lontracanadensis.net/texts/"
# site_url = "localhost:3000/texts/"

field_name = "genre"

file_path = Rails.root.join('scripts', 'reports', 'output')
FileUtils.mkdir_p(file_path) unless File.directory?(file_path)

file_name = file_path.to_s + "/greek-census_component_#{field_name}-#{time_stamp_file_name}.html"

genres =  Component.pluck(:genre).uniq
genres_sorted = genres.sort { |a,b| a && b ? a <=> b : a ? -1 : 1 }

output = File.open(file_name, "w")

output.puts "<!doctype html><html lang='en'>"
output.puts "<head>"
output.puts "<meta charset='utf-8'>"
output.puts "<title>Component #{field_name} - #{time_stamp_readable}</title>"
output.puts "<style>"
output.puts "body{font-family:Arial, Helvetica, sans-serif;}"
output.puts "ul{-webkit-column-count:10; -moz-column-count:10; column-count:10; padding-left:0;}"
output.puts "li{display: inline-block; padding:0 0 .25rem 0; width: 7ch; text-align: left; font-family:'Lucida Console', Monaco, monospace;}"
output.puts "@media print { a{text-decoration:none;} }"
output.puts "</style>"
output.puts "</head><body>"
output.puts "<h1>List of all Component <em>#{field_name}</em> records</h1><p>Loaded: #{time_stamp_readable}<pre></pre>"

genres_sorted.each do |genre|
  if genre == nil
    output.puts "<h2><em>none (no value)</em></h2>"
  elsif genre == ""
    output.puts "<h2><em>none (blank value)</em></h2>"
  else
    output.puts "<h2>'#{genre}'</h2>"
  end

  components = Component.where(:genre => genre).order(:text_id)

  # get list of all unique text ids and a hash of text.id and text.census_id
  text_ids = []
  text_hashes = []
  components.each do |comp|
    if text_ids.include? comp.text.id
    else
      text_ids << comp.text.id
      text_hashes << {id: comp.text.id, census_id: comp.text.census_id}
    end
  end

  # sort list of hashes
  text_hashes_sorted = text_hashes.sort_by(&:zip)

  # output list of hashes
  output.puts "<ul>"
  text_hashes_sorted.each do |text|
    output.puts "<li><a href='#{site_url}#{text[:id]}' target='_blank'>#{text[:census_id]}</a></li>"
  end
  output.puts "</ul>"

end
output.puts "</body>"

time_stamp_finish = Time.now
diff = time_stamp_finish - time_stamp_start

puts "Completed script in #{diff} seconds."

output.close
