class AddAbstractToText < ActiveRecord::Migration[5.1]
  def change
    add_column :texts, :abstract, :text
  end
end
