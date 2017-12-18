regex = /\(([a-zA-Z\.]+)\)$/

Person.find_each do |person|
  domicile = person.full_name[regex, 1]
  unless domicile
    next
  end
  person.domicile = domicile
  person.save
end