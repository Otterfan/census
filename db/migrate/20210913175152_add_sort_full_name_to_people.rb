class AddSortFullNameToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :sort_full_name, :text
  end
end
