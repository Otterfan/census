class AddTypeToText < ActiveRecord::Migration[5.1]
  def change
    add_column :texts, :type, :string
  end
end