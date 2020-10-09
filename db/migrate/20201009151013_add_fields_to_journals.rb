class AddFieldsToJournals < ActiveRecord::Migration[5.2]
  def change
    add_column :journals, :eissn, :string
    add_column :journals, :issn_1, :string
    add_column :journals, :issn_2, :string
    add_column :journals, :issn_3, :string
    add_column :journals, :url, :string
    add_column :journals, :first_published, :string
    add_column :journals, :notes, :text
  end
end
