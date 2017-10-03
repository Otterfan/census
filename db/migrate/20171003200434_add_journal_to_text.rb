class AddJournalToText < ActiveRecord::Migration[5.1]
  def change
    add_reference :texts, :journal, foreign_key: true
  end
end
