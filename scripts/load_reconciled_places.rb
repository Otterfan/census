require 'csv'
ActiveRecord::Base.logger.silence do

  places_file = "./places_census.csv"

  CSV.foreach(places_file) do |row|
    Place.update(row[0], :name => row[1], :country_id => row[5], :latitude => row[2], :longitude => row[3], :subdivision => row[6])
  end
end