def reverse_name_if_necessary(name)
    return name if name.include? ','
    return name if name.include? 'the author'

    name_components = name.split(' ')
    return name if name_components.length < 2
    return name if name_components.length > 3

    name_components[1] + ', ' + name_components[0]
end

puts 'Starting...'

TextCitation.where('created_at > ? AND name NOT LIKE ?', '2010-01-01', '%,%').each do |citation|
    original_name = citation.name
    puts "Evaluating #{citation.name}"
    citation.name.lstrip!
    citation.name.sub!("\\", "")
    citation.name.sub!("*", "")
    citation.name = reverse_name_if_necessary(citation.name)
    citation.controlled_name = citation.name
    if original_name != citation.name
        puts "Saving #{citation.name}"
        citation.save
        sleep 0.25
    end
end