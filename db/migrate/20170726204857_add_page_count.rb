class AddPageCount < ActiveRecord::Migration[5.1]
  def change
    rename_column :texts, :pages, :page_span
    add_column :texts, :page_count, :string
  end
end
