reviewed = Status.find(2)

Text.find_each do |text|
    text.status=reviewed
    text.save
    sleep(3)
end