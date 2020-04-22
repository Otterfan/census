require 'json'
require 'pathname'


def main
    json_entries = read_file
    json_entries.each do |json_entry|
        if json_entry['entry_type'].include? 'study'
            update_entry(json_entry['id'], json_entry['entry_type'], json_entry['responsibility'])
        end
    end
end

def read_file
    contents = File.read('/Users/benjaminflorin/RubymineProjects/census/data/authors-k-v1.json')
    JSON.parse(contents)
end

def update_entry(census_id, text_type, responsibility)
    entry = Text.find_by_census_id(census_id)
    entry.genre = 'Study'
    entry.text_type = text_type
    if entry.authors_name_from_source == responsibility
        entry.authors_name_from_source = ''
    end
    entry.save
    sleep(1.0)
end

# Run main code
main