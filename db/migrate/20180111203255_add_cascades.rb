class AddCascades < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :component_citations, :components
    add_foreign_key :component_citations, :components, on_delete: :cascade
  end
end
