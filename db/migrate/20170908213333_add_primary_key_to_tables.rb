class AddPrimaryKeyToTables < ActiveRecord::Migration[5.1]
  def change
    reversible do |direction|
      direction.up {add_pks}
      direction.down {remove_pks}
    end
  end

  def add_pks
    add_column :publication_places, :id, :primary_key
    add_column :other_text_languages, :id, :primary_key
  end


  def remove_pks
    remove_column :publication_places, :id
    remove_column :other_text_languages, :id
  end
end
