class AddSortPageSpanToTexts < ActiveRecord::Migration[5.2]
  def change
    add_column :texts, :sort_page_span, :integer
    add_index :texts, :sort_page_span
  end
end
