Text.where(text_type: 'study_part').each do |text|
    text.genre = 'study'
    text.save
end

Text.where(text_type: 'study_book').each do |text|
    text.genre = 'study'
    text.save
end