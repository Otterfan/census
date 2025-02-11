class AddDisplayToSections < ActiveRecord::Migration[6.1]
  def change
    add_column :sections, :display, :string
  end
end
