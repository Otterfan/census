class AddRoleToTextCitations < ActiveRecord::Migration[5.1]
  def change
    add_column :text_citations, :role, :string
  end
end
