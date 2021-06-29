class AddSortAuthorToTexts < ActiveRecord::Migration[5.2]
  def change
    add_column :texts, :sort_author, :text
    add_index :texts, :sort_author
  end
end
