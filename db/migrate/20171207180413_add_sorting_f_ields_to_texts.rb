class AddSortingFIeldsToTexts < ActiveRecord::Migration[5.1]
  def change
    add_column :texts, :sort_id, :int
    add_index :texts, :sort_id
    Text.find_each do |text|
      census_id_parts = text.census_id.split('.')
      sort_id = census_id_parts[0] + census_id_parts[1].rjust(7, '0')
      text.sort_id = sort_id
      text.save
    end
  end
end
