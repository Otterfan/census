class AddCollectionToComponents < ActiveRecord::Migration[5.1]
  def change
    add_column :components, :collection, :text
  end
end
