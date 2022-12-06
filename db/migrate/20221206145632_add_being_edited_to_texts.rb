class AddBeingEditedToTexts < ActiveRecord::Migration[5.2]
  def change
    add_column :texts, :being_edited, :boolean, :default => false
  end
end
