def reverse_name_if_necessary(name)
  return name if name.include? ','
  return name if name.include? 'the author'

  name_components = name.split(' ')
  return name if name_components.length < 2

  name_components[1] + ', ' + name_components[0]
end

TextCitation.find_each do |citation|
  citation.name.lstrip!
  citation.name.sub!("\\","")
  citation.name.sub!("*","")
  citation.name = reverse_name_if_necessary(citation.name)
  citation.save
  puts citation.name
end