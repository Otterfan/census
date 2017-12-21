class AddMainPlaceOfPublicationToPublicationPlaces < ActiveRecord::Migration[5.1]
  def change
    add_column :publication_places, :primary, :boolean
  end
end
