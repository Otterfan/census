class BuildPlaces < ActiveRecord::Migration[5.1]
  def change
    reversible do |direction|
      direction.up {build_places}
      direction.down {destroy_places}
    end
  end

  def build_places

    result_set = Text.select(:place_of_publication)

    seen = []

    result_set.each do |selected_text|

      next if selected_text.place_of_publication.nil?
      next if seen.include? selected_text.place_of_publication

      seen << selected_text.place_of_publication

      place = Place.new(name: selected_text.place_of_publication)
      place.save!

      Text.where(place_of_publication: selected_text.place_of_publication).each do |text|
        pub_place = PublicationPlace.new(text: text, place: place)
        pub_place.save!
      end

    end
  end

  def destroy_places
    PublicationPlace.delete_all
    Place.delete_all
  end
end
