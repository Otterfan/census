class AddMoreFieldsToTexts < ActiveRecord::Migration[5.1]
  def change
    add_column :texts, :authors_name_from_source, :text
    add_column :texts, :editorial_annotation, :text
    add_column :texts, :physical_description, :text
    add_column :texts, :original_greek_collection, :string
  end
end
