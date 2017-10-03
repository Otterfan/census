class CreateJournals < ActiveRecord::Migration[5.1]
  def change
    create_table :journals do |t|
      t.text :title
      t.string :issn
      t.text :description
      t.belongs_to :place
      t.text :sort_title
      t.timestamps
    end
  end
end
