class AddOrdinalToTextCitations < ActiveRecord::Migration[5.1]
  def change
    add_column :text_citations, :ordinal, :integer, :default => 0
    add_index :text_citations, :ordinal
  end
end
