Language.find_each do |lang|
  lang.ordinal = lang.ordinal + 1
  lang.save
end

english = Language.new
english.code='eng'
english.name='English'
english.ordinal=1
english.save