class AddDirectFieldsToComponentCitation < ActiveRecord::Migration[5.1]
  def change
    remove_reference :component_citations, :role
    remove_reference :component_citations, :person
    add_column :component_citations, :name, :string
    add_column :component_citations, :role, :string
  end
end
