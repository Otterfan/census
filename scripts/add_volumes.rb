regex = /In (his|her)? ?_([^_]+)_/

Text.find_each do |text|
  unless text.original
    next
  end

  title = text.original[regex, 2]

  unless title
    next
  end

  volume = Volume.find_by_title(title)

  if volume
    puts volume.title
  else
    sort_title = title.sub(/^The +/, '').sub(/^An +/, '').sub(/^A +/, '')
    volume = Volume.create(title: title, sort_title: sort_title)
    text.volume = volume
    text.save
  end
end