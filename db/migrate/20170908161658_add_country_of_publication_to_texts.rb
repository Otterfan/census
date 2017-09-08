class AddCountryOfPublicationToTexts < ActiveRecord::Migration[5.1]
  def change
    add_reference :texts, :country, foreign_key: true
    rename_column :texts, :location, :place_of_publication
  end
end
