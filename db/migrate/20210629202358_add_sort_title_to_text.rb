class AddSortTitleToText < ActiveRecord::Migration[5.2]
  def change
    add_column :texts, :sort_title, :text
    add_index :texts, :sort_title
  end
end