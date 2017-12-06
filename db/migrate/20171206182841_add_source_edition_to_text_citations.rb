class AddSourceEditionToTextCitations < ActiveRecord::Migration[5.1]
  def change
    add_column :text_citations, :source_edition, :text
  end
end
