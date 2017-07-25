class RenameGreekTitleToSource < ActiveRecord::Migration[5.1]
  def change
    rename_column :texts, :greek_title, :source
  end
end
