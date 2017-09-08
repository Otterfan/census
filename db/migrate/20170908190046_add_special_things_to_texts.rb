class AddSpecialThingsToTexts < ActiveRecord::Migration[5.1]
  def change
    add_column :texts, :special_location_of_item, :text
    add_column :texts, :special_source_of_info, :text
  end
end
