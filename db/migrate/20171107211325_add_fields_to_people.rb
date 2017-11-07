class AddFieldsToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :viaf, :string
    add_column :people, :loc, :string
    add_column :people, :greek_authority, :string
  end
end
