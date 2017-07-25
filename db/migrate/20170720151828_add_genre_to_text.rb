class AddGenreToText < ActiveRecord::Migration[5.1]
  def change
    add_column :texts, :genre, :string
  end
end
