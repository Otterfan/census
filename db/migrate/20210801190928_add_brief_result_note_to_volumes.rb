class AddBriefResultNoteToVolumes < ActiveRecord::Migration[5.2]
  def change
    add_column :volumes, :brief_result_note, :text
  end
end
