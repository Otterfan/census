def main
  entries = read_file

  entries.each do |entry|
    text = Text.find_by_census_id entry['id']

    puts "\tAdding components..."

    entry['components'].each do |component_entry|
      text.components << add_component(component_entry, text)
    end

    unless text.save()
      puts.text.errors.messages
      exit!
    end

    sleep 1
  end

end

def read_file
  contents = File.read('/Users/benjaminflorin/RubymineProjects/census/data/edited-r.json')
  JSON.parse(contents)
end


def add_component(component_entry, text)

  puts "\t\tAdding component #{component_entry['title']}"

  component = Component.new
  component.title = component_entry['title'] || ''

  component.pages = component_entry['pages'] || ''
  component.ordinal = component_entry['position'] || 0

  component.text_type = component_entry['type'] || ''

  component.collection = component_entry['from'] || ''

  if component_entry['author']
    author = build_component_citation(component_entry['author'], 'author')
    component.component_citations << author
  end

  if component_entry['translator']
    author = build_component_citation(component_entry['translator'], 'translator')
    component.component_citations << author
  end

  component.is_bilingual = component_entry['is_bilingual']

  component
end

def build_component_citation(name, role)

  puts "\t\tAdding component citation #{name}"

  citation = ComponentCitation.new
  citation.name = name
  name_parts = name.split(', ')
  citation.last_name = name_parts[1]
  citation.first_name = name_parts[0]
  citation.role = role
  citation
end

main

