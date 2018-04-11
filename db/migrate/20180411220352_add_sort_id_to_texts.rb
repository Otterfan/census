class AddSortIdToTexts < ActiveRecord::Migration[5.1]
  def change
    add_column :texts, :sort_census_id, :text
  end
end
