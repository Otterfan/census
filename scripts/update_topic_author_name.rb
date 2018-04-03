Person.where(topic_flag: true).each do |person|
  person.full_name.gsub!(/\(=([^\)]*)\)/, '[=\1]')
  person.full_name.gsub!(/\(.*?\)/, "")
  person.full_name.gsub!(/\[=(.*)\]/, '(=\1)')
  person.save
end