class AddLangaugesToComponentCitations < ActiveRecord::Migration[5.1]
  def change
    add_reference :component_citations, :from_language, foreign_key: {to_table: :languages}
    add_reference :component_citations, :to_language, foreign_key: {to_table: :languages}
  end
end
