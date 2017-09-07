class AddMissingFieldsToText < ActiveRecord::Migration[5.1]
  def change
    add_column :texts, :format, :string
    add_reference :texts, :intermediary_language, foreign_key: {to_table: :languages}
    add_column :texts, :is_bilingual, :boolean
  end
end
