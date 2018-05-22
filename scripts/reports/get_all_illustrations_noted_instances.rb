# Get a list of all Text records that have a specific illustrations_noted value.
#
# Run this script from a rails console:
# load './scripts/get_all_illustrations_noted_instances.rb'

time_stamp_start = Time.now
time_stamp_file_name = time_stamp_start.strftime('%Y%m%d-%H%M%S')
time_stamp_readable = time_stamp_start.strftime('%B %d %Y %H:%M%p')

site_url = "https://www.lontracanadensis.net/texts/"
# site_url = "localhost:3000/texts/"

field_name = "illustrations_noted"

file_name = Rails.root.join('scripts', 'reports', 'output', "greek-census_#{field_name}-#{time_stamp_file_name}.html")

illustrations_notes =  Text.pluck(:illustrations_noted).uniq
illustrations_notes_sorted = illustrations_notes.sort { |a,b| a && b ? a <=> b : a ? -1 : 1 }

output = File.open(file_name, "w")

output.puts "<!doctype html><html lang='en'>"
output.puts "<head>"
output.puts "<meta charset='utf-8'>"
output.puts "<title>Text #{field_name} - #{time_stamp_readable}</title>"
output.puts "<style>"
output.puts "body{font-family:Arial, Helvetica, sans-serif;}"
output.puts "ul{-webkit-column-count:10; -moz-column-count:10; column-count:10; padding-left:0;}"
output.puts "li{display: inline-block; padding:0 0 .25rem 0; width: 7ch; text-align: left; font-family:'Lucida Console', Monaco, monospace;}"
output.puts "@media print { a{text-decoration:none;} }"
output.puts "</style>"
output.puts "</head><body>"
output.puts "<h1>List of all Text <em>#{field_name}</em> records</h1><p>Loaded: #{time_stamp_readable}<pre></pre>"

illustrations_notes_sorted.each do |ill_note|
  if ill_note == nil
    output.puts "<h2><em>none (no value)</em></h2>"
  elsif ill_note == ""
    output.puts "<h2><em>none (empty value)</em></h2>"
  else
    output.puts "<h2>'#{ill_note}'</h2>"
  end

  texts = Text.where(:illustrations_noted => ill_note).order(:sort_census_id)

  output.puts "<ul>"
  texts.each do |text|
    output.puts "<li><a href='#{site_url}#{text.id}' target='_blank'>#{text.census_id}</a></li>"
  end
  output.puts "</ul>"
end
output.puts "</body>"

time_stamp_finish = Time.now
diff = time_stamp_finish - time_stamp_start

puts "Completed script in #{diff} seconds."

output.close
