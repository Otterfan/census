class MoveMaterialTypeToText < ActiveRecord::Migration[5.1]
  def change
    remove_column :components, :material_type
    add_column :texts, :material_type, :string
  end
end
