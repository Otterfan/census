class AddFieldsToTexts < ActiveRecord::Migration[5.1]
  def change
    add_column :texts, :url, :text
    add_column :texts, :contents, :text
    add_column :texts, :sponsoring_organization, :text
  end
end
