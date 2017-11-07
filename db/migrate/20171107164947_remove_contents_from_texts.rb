class RemoveContentsFromTexts < ActiveRecord::Migration[5.1]
  def change
    remove_column :texts, :contents
  end
end