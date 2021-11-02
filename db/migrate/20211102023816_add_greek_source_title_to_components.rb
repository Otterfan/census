class AddGreekSourceTitleToComponents < ActiveRecord::Migration[5.2]
  def change
    add_column :components, :greek_source_title, :text
    add_index :components, :greek_source_title

    add_column :texts, :greek_source_title, :text
    add_index :texts, :greek_source_title
  end
end
