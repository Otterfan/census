class AddLanguagesToCitation < ActiveRecord::Migration[5.1]
  def change
    add_reference :text_citations, :from_language, foreign_key: {to_table: :languages}
    add_reference :text_citations, :to_language, foreign_key: {to_table: :languages}
  end
end
