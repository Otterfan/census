class AddSeeRecordToJournals < ActiveRecord::Migration[5.2]
  def change
    add_reference :journals, :see_journal, foreign_key: {to_table: :journals}
  end
end
