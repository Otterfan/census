require 'json'
require 'pathname'

def main
  json_entries = read_file

  json_entries.each do |json_entry|
    update_entry(json_entry['id'], json_entry)
  end
end

def read_file
  contents = File.read('/Users/benjaminflorin/RubymineProjects/census/data/authors-l-o-v2.json')
  JSON.parse(contents)
end

def update_entry(census_id, json_entry)
  touched = false
  entry = Text.find_by_census_id(census_id)

  if entry.census_id === '4.2998' || entry.census_id == '4.2997'
    entry.components = []
    entry.title = json_entry['title']
    puts "Changing #{census_id}: #{entry.title} to #{json_entry['title']}"
    json_entry['components'].each do |component_entry|
      entry.components << add_component(component_entry)
    end
    touched = true
  end

  if entry.title == ""
    puts "Changing #{census_id}: #{entry.title} to #{json_entry['title']}"
    entry.title = json_entry['title']
    touched = true
  end

  if touched
    entry.save
    sleep(1.0)
  end

end

def add_component(component_entry)
  puts "\t\tAdding component #{component_entry['title']}"
  component = Component.create
  component.title = component_entry['title'] || ''
  component.pages = component_entry['pages'] || ''
  component.ordinal = component_entry['position'] || 0
  component.text_type = component_entry['type'] || ''
  component.collection = component_entry['from'] || ''
  component
end

# Run main code
main