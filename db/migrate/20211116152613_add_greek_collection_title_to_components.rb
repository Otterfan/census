class AddGreekCollectionTitleToComponents < ActiveRecord::Migration[5.2]
  def change
    add_column :components, :greek_collection_title, :text
    add_index :components, :greek_collection_title
  end
end
