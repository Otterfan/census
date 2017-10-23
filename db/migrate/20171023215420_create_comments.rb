class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :value
      t.references :user, foreign_key: true
      t.references :text, foreign_key: true

      t.timestamps
    end
  end
end
