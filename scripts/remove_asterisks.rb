Component.where('title LIKE ?', '%**%').each do |component|
    component.title.tr!('*','')
    component.save
    sleep(1)
end