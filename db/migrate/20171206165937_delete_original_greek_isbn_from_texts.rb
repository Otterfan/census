class DeleteOriginalGreekIsbnFromTexts < ActiveRecord::Migration[5.1]
  def change
    remove_column :texts, :original_greek_isbn
  end
end
