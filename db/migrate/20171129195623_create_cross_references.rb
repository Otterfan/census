class CreateCrossReferences < ActiveRecord::Migration[5.1]
  def change
    create_table :cross_references do |t|
      t.string :census_id
      t.references :text, foreign_key: true

      t.timestamps
    end
  end
end
