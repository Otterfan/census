class AddCollectionToText < ActiveRecord::Migration[5.1]
  def change
    add_column :texts, :collection, :string
  end
end
