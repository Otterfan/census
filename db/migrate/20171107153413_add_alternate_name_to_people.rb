class AddAlternateNameToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :alternate_name, :string
  end
end
