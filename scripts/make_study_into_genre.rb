Text.where(genre: 'study').each do |text|
    text.genre = 'Study'
    text.save
end