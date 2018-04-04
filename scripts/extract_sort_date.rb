Text.where('date IS NOT NULL').each do |text|
  sort_date = text.date[/\d\d\d\d/]
  text.sort_date = "#{sort_date}-01-01"
  text.save()
end