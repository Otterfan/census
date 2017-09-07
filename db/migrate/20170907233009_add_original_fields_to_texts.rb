class AddOriginalFieldsToTexts < ActiveRecord::Migration[5.1]
  def change
    add_column :texts, :original_greek_title, :string
    add_index :texts, :original_greek_title
    add_column :texts, :original_greek_place_of_publication, :string
    add_column :texts, :original_greek_publisher, :string
    add_column :texts, :original_greek_date, :string
    add_column :texts, :original_greek_isbn, :string
    add_column :texts, :original_greek_edition, :string
  end
end