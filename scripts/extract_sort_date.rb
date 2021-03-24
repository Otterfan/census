Text.where.not(date: [nil]).where(sort_date: [nil]).each do |text|
  text.save()
  sleep 0.25
end