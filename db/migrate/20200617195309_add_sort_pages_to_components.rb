class AddSortPagesToComponents < ActiveRecord::Migration[5.2]
  def change
    add_column :components, :sort_pages, :integer
    add_index :components, :sort_pages
  end
end
