ComponentCitation.find_each do |citation|
  citation.name.strip!
  citation.name.gsub(/  +/, ' ')
  citation.save
end

TextCitation.find_each do |citation|
  citation.name.strip!
  citation.name.gsub(/  +/, ' ')
  citation.save
end