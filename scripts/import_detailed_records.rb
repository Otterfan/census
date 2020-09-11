require 'json'
require 'pathname'

TO_IMPORT = %w(4.371)

def main
  TO_IMPORT.each do |census_id|
    json_record = read_file census_id
    add_record json_record
  end
end

def read_file(census_id)
  filename = '../data/' + census_id + '.json'
  json_file = File.join(File.dirname(__FILE__), filename)
  contents = File.read(json_file)
  JSON.parse(contents)
end

def add_record(json_record)
  text = Text.find_by_census_id json_record['entry']
  puts text.title

  text.components.destroy_all

  count = 0

  json_record['contains'].each do |json_component|
    component = build_component json_component
    component.text = text
    component.ordinal = count
    count = count + 1
    component.save

  end

  text.save
end

def build_component(json_record)
  component = Component.new
  component.title = json_record['title']
  component.pages = json_record['page_span']
  component.section = json_record['section']
  component.collection = json_record['section']
  component.subsection = json_record['subsection']
  component.genre = json_record['genre']
  component.text_type = json_record['type']

  component
end

main