class AddFieldsToComponent < ActiveRecord::Migration[5.1]
  def change
    add_column :components, :material_type, :string
    add_column :components, :genre, :string
    add_column :components, :text_type, :string
  end
end
