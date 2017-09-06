require 'json'
require 'pathname'

json_file = File.join(File.dirname(__FILE__), "../data/a-c-with-types.json")
contents = File.read(json_file)
entries = JSON.parse(contents)
entries.each do |entry|
  text = Text.find_by census_id: entry['id']
  text.text_type = entry['entry_type']
  text.save
end