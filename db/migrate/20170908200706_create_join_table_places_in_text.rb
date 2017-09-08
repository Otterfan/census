class CreateJoinTablePlacesInText < ActiveRecord::Migration[5.1]
  def change
    create_join_table :places, :texts, {:table_name => 'publication_places'} do |t|
      t.index [:place_id, :text_id]
      t.index [:text_id, :place_id]
    end
  end
end
