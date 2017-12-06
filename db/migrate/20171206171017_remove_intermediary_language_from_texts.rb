class RemoveIntermediaryLanguageFromTexts < ActiveRecord::Migration[5.1]
  def change
    remove_column :texts, :intermediary_language_id
  end
end
