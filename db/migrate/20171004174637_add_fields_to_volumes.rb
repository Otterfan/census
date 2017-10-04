class AddFieldsToVolumes < ActiveRecord::Migration[5.1]
  def change
    add_column :volumes, :editor, :string
    add_column :volumes, :conference_title, :string
    add_column :volumes, :conference_place, :string
    add_column :volumes, :conference_date, :string
  end
end
