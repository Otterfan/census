class CreateVolumes < ActiveRecord::Migration[5.1]
  def change
    create_table :volumes do |t|
      t.text :title
      t.text :author
      t.string :date
      t.text :sort_title
      t.timestamps
    end
    add_reference :texts, :volume, foreign_key: true
  end
end
