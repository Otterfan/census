class RenameTypeToCategory < ActiveRecord::Migration[5.1]
  def change
    rename_column :texts, :type, :text_type
  end
end
