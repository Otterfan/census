class DropStandardIdentifiers < ActiveRecord::Migration[5.1]
  def change
    drop_table :standard_identifiers
    drop_table :standard_identifier_types
  end
end
