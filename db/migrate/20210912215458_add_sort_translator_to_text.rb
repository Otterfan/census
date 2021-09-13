class AddSortTranslatorToText < ActiveRecord::Migration[5.2]
  def change
    add_column :texts, :sort_translator, :string
  end
end
