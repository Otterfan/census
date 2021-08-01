class AddPublicNoteToJournals < ActiveRecord::Migration[5.2]
  def change
    add_column :journals, :brief_result_note, :text
  end
end
