require 'json'
require 'pathname'


def main
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

        unless text.save()
            puts.text.errors.messages
            exit!
        end
        sleep(1)
    end
end

def read_file
    contents = File.read('/Users/benjaminflorin/RubymineProjects/census/data/authors-l-o-final.json')
    JSON.parse(contents)
end

def add_text_citation(full_name, role, ordinal)

    puts "\t\tAdding text citation #{full_name}"

    citation = TextCitation.create()

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

    text = Text.create()

    text.is_hidden = true

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
        text.text_type = 'Study'
    elsif entry['genre']
        text.genre = entry['genre'] || ''
    else
        text.title.include?('')
    end

    text.page_span = entry['page_count'] || ''

    text.publisher = entry['publisher'] || ''

    if entry['isbns']
        entry['isbns'].each do |isbn|
            stdnum = StandardNumber.create
            stdnum.value = isbn
            stdnum.text = text
            stdnum.numtype = 'ISBN'
        end
    end

    puts "\tAdding components..."

    entry['components'].each do |component_entry|
        text.components << add_component(component_entry, text)
    end

    puts "\tAdding authors names..."

    text.authors_name_from_source = entry['responsibility']

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

    census_id_parts = text.census_id.split('.')

    text.sort_census_id = "04" + "%06d" % census_id_parts[1]

    text
end

def add_component(component_entry, text)

    puts "\t\tAdding component #{component_entry['title']}"

    component = Component.create
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

    component
end

def build_component_citation(name, role)

    puts "\t\tAdding component citation #{name}"

    citation = ComponentCitation.new
    citation.name = name
    name_parts = name.split(', ')
    citation.last_name = name_parts[0]
    if (name_parts[1])
        citation.first_name = name_parts[1]
    end
    citation.role = role
    citation
end

def add_topic_author(entry, topic_author_full)

    puts "\t\tAdding topic author #{topic_author_full}"

    topic_author_greek = entry['topic_author']['full_name']
    topic_author = Person.create()
    topic_author.full_name = topic_author_full
    topic_author.greek_full_name = topic_author_greek

    unless topic_author.save()
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

# Run main code
main