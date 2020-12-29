require 'json'
require 'pathname'

namespace :census do
  desc "Import new records"
  task import_records: :environment do
    import_new_records
  end
end

def import_new_records
  entries = read_file

  topic_author_full = ''

  topic_author = nil

  needs_review_status = Status.find(1)

  section = Section.find(1)

  entries.each do |entry|
    if entry['topic_author']['full_name'] != topic_author_full
      topic_author_full = entry['topic_author']['full_name']
      #topic_author = add_topic_author(entry, topic_author_full)

      topic_author_just_name = topic_author_full[/[^(]+/].strip

      topic_author = Person.find_by(topic_flag: true, full_name: topic_author_just_name)
      unless topic_author
        topic_author = Person.new
        topic_author_full = topic_author_just_name
      end
    end

    text = add_text(entry, needs_review_status)
    text.topic_author = topic_author || nil

    text.section = section

    unless text.save
      puts text.errors.messages
      exit!
    end
    sleep(1)
  end
end

def read_file
  import_file_path = Rails.root.join('import-data.json')
  contents = File.read(import_file_path)
  JSON.parse(contents)
end

def add_text_citation(full_name, role, ordinal)

  puts "\t\tAdding text citation #{full_name}"

  citation = TextCitation.new

  if full_name
    if full_name.include?(', ')
      name_parts = full_name.split(', ')
      citation.last_name = name_parts.first
      citation.first_name = name_parts.last
    else
      name_parts = full_name.split(' ')
      citation.last_name = name_parts.last
      if citation.last_name
        citation.first_name = full_name.gsub(citation.last_name, '')
      end
    end
    citation.name = "#{citation.last_name}, #{citation.first_name}"
  else
    puts "\tNo full name!"
  end


  citation.role = role
  citation.ordinal = ordinal
  citation.controlled_name = citation.name

  citation
end

def add_text(entry, needs_review_status)

  puts "Adding text #{entry['id']}"
  citation_ordinal = 0

  text = Text.new

  text.is_hidden = false

  text.status = needs_review_status

  text.note = entry['notes'][0] if entry['notes']

  text.seen_in_person = entry['seen']

  text.census_id = entry['id'] || ''
  text.title = entry['title'] || ''
  text.original = entry['full_text'] || ''
  text.date = entry['date'] || ''
  text.text_type = entry['entry_type']

  puts "\tAdding text type..."

  if text.text_type.include?('study')
    text.genre = nil
  elsif entry['genre']
    text.genre = entry['genre'] || ''
  else
    text.title.include?('')
  end

  text.page_span = entry['page_count'] || ''

  text.publisher = entry['publisher'] || ''

  if entry['isbns']
    entry['isbns'].each do |isbn|
      standard_number = StandardNumber.new
      standard_number.value = isbn
      standard_number.text = text
      standard_number.numtype = 'ISBN'
    end
  end

  puts "\tAdding components..."

  entry['components'].each do |component_entry|
    text.components << add_component(component_entry, text)
  end

  puts "\tAdding authors names..."

  if text.text_type.include?('translation')
    text.authors_name_from_source = entry['responsibility']
  end

  text.text_citations << add_text_citation(entry['responsibility'], 'author', citation_ordinal)
  citation_ordinal = citation_ordinal + 1

  puts "\tAdding translator..."

  if entry['translator']
    text.text_citations << add_text_citation(entry['translator'], 'translator', citation_ordinal)
    citation_ordinal = citation_ordinal + 1
  end

  puts "\tAdding contributors..."

  entry['contributors'].each do |contributor|
    if contributor['role'] != 'author'
      text.text_citations << add_text_citation(contributor['name'], contributor['role'], citation_ordinal)
      citation_ordinal = citation_ordinal + 1
    end
  end

  if entry['journal_title']
    add_journal(entry, text)
  end

  assign_material_type(text)
  assign_genre(text)

  text
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

  component.is_bilingual = component_entry['is_bilingual']

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
  citation.last_name = name_parts[0]
  if name_parts[1]
    citation.first_name = name_parts[1]
  end
  citation.role = role
  citation
end

def add_topic_author(entry, topic_author_full)

  puts "\t\tAdding topic author #{topic_author_full}"

  topic_author_greek = entry['topic_author']['full_name']
  topic_author = Person.new
  topic_author.full_name = topic_author_full
  topic_author.greek_full_name = topic_author_greek

  unless topic_author.save
    puts topic_author.errors.messages
    exit!
  end
  sleep(1)
  topic_author
end

def add_journal(entry, text)

  puts "\t\tAdding journal #{entry['journal_title']}"

  text.journal_title = entry['journal_title']

  journal = Journal.find_by(title: entry['journal_title'])
  text.journal = journal if journal

  if entry['journal_issue']
    text.issue_volume = entry['journal_issue']
  end
end

# @param [Text] text
def assign_material_type(text)
  downcased_original = text.original
  if downcased_original.include?('thesis') || downcased_original.include?('dissertation')
    text.material_type = 'Thesis/dissertation'
  elsif downcased_original.include?('proceedings')
    text.material_type = 'Conference proceedings'
  elsif downcased_original.include?('online')
    text.material_type = 'Online'
  elsif downcased_original.include?('isbn')
    text.material_type = 'Book'
  elsif text.text_type.include?('book')
    text.material_type = 'Book'
  elsif text.text_type.include?('part')
    text.material_type = 'Journal'
  end
end

# @param [Text] text
def assign_genre(text)

  # Study? no genre
  if text.text_type.include?('study')
    text.genre = nil
    return
  end

  # Already a genre? Go with it
  return if text.genre

  # Look in text for clues
  downcased_original = text.original
  if downcased_original.include?('poetry') || downcased_original.include?('poem')
    text.genre = 'Poetry'
  elsif downcased_original.include?('essay')
    text.genre = 'Essay'
  elsif downcased_original.include?('novel')
    text.genre = 'Novel'
  elsif downcased_original.include? ('short stor') || downcased_original.include?('stories')
    text.genre = 'Short story'
  end

end