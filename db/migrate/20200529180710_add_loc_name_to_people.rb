class AddLocNameToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :loc_name, :string
  end
end
