Journal.find_each do |journal|
  if journal.place
    journal.texts.each do |text|
      if text.publication_places.empty?
        puts text.title
        pub_place = PublicationPlace.new
        pub_place.text = text
        pub_place.place = journal.place
        text.publication_places << pub_place
        text.save
      end
    end
  end
end