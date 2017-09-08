class CreatePlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :places do |t|
      t.string :name
      t.references :country, foreign_key: true
      t.string :latitude
      t.string :longitude
      t.string :subdivision

      t.timestamps
    end
  end
end
