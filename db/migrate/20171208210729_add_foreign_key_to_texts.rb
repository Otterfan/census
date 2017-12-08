class AddForeignKeyToTexts < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :texts, :languages
    add_foreign_key :texts, :languages, on_delete: :nullify

    remove_foreign_key :texts, :statuses
    add_foreign_key :texts, :statuses, on_delete: :nullify

    remove_foreign_key :texts, :sections
    add_foreign_key :texts, :sections, on_delete: :nullify

    remove_foreign_key :texts, :countries
    add_foreign_key :texts, :countries, on_delete: :nullify

    remove_foreign_key :texts, :journals
    add_foreign_key :texts, :journals, on_delete: :nullify

    remove_foreign_key :texts, :volumes
    add_foreign_key :texts, :volumes, on_delete: :nullify
  end
end
