def extract_collection(component)
  regex = /^ *[F,f]rom (the collection )?(.*)/
  component.collection = component.note[regex, 2]

  if component.collection
    if component.collection =~ /\. +([Ff]rom)/
      collection_parts = component.collection.split('.')
      component.collection = collection_parts[0]
      component.note = collection_parts[1].strip
    else
      component.note = ''
    end
    component.collection.chomp!('.')
  end
end

Component.find_each do |component|
  if component.note
    extract_collection(component)
    if component.collection
      puts component.collection
      puts component.note
    end
    component.save
  end
end