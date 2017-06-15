class CreateStandardNumbers < ActiveRecord::Migration[5.1]
  def change
    create_table :standard_numbers do |t|
      t.string :value
      t.references :text, foreign_key: true

      t.timestamps
    end
  end
end
