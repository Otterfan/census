class DeleteFormatFromTexts < ActiveRecord::Migration[5.1]
  def change
    remove_column(:texts, :format)
    remove_column(:texts, :parent_title)
  end
end
