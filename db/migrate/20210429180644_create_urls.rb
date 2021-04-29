class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.text :value
      t.date :accessed_on
      t.text :wayback
      t.belongs_to :text

      t.timestamps
    end

    add_index :urls, [:text_id, :value], unique: true
  end
end
