puts 'Fixing angle brackets'

Text.where('original ~* ?', '<poetry>').each do |text|
  text.original.sub! '<poetry>', ''
  text.original.sub! '</poetry>', ''
  text.save
end

Text.where('original ~* ?', '<prose>').each do |text|
  text.original.sub! '<prose>', ''
  text.original.sub! '</prose>', ''
  text.save
end