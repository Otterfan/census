class AddAccessedOnToText < ActiveRecord::Migration[5.2]
  def change
    add_column :texts, :accessed_on, :date
  end
end
