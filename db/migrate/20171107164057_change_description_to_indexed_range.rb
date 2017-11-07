class ChangeDescriptionToIndexedRange < ActiveRecord::Migration[5.1]
  def change
    rename_column :journals, :description, :indexed_range
  end
end
