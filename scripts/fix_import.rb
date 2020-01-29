def reverse_name_if_necessary(name)
    return name if name.include? ','
    return name if name.include? 'the author'

    name_components = name.split(' ')
    return name if name_components.length < 2

    name_components[1] + ', ' + name_components[0]
end

def fix_name(citation)
    # Skip strange things
    return if citation.name.include? 'the author'

    citation.name.strip! if citation.name
    citation.controlled_name = citation.name

    puts "Added controlled name for #{citation.name}"

    citation
end

def reverse_name citation
    if citation.ordinal == 0 && citation.role == 'author' && citation.last_name && citation.first_name
        citation.last_name.strip!
        citation.first_name.strip!

        new_first_name = citation.last_name
        new_last_name = citation.first_name
        citation.first_name = new_first_name
        citation.last_name = new_last_name

        citation.name = "#{citation.last_name}, #{citation.first_name}"

        puts "Updated to #{citation.name}"
    end

    citation
end

Text.where('created_at > ?', '2020-01-01').each do |text|
    puts 'Changing ' + text.census_id

    text.text_citations.each do |citation|
        if text.text_type == 'study_part' || text.text_type == 'study_book'
            reverse_name citation
        end
        fix_name citation
        citation.save
        sleep 1
    end

    text.authors_name_from_source = ''
    text.save
    sleep 1
end