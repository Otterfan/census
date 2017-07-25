class AddJournalTitleToTexts < ActiveRecord::Migration[5.1]
  def change
    add_column :texts, :journal_title, :string
  end
end
