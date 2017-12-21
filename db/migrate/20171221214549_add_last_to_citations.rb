class AddLastToCitations < ActiveRecord::Migration[5.1]
  def change
    add_column :text_citations, :first_name, :string
    add_column :text_citations, :last_name, :string
    add_column :component_citations, :first_name, :string
    add_column :component_citations, :last_name, :string
  end
end
