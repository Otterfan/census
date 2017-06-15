class AddParentToText < ActiveRecord::Migration[5.1]
  def change
    add_column :texts, :parent_title, :string
    add_column :texts, :parent_issue, :string
  end
end
