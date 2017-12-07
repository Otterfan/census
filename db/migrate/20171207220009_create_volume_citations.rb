class CreateVolumeCitations < ActiveRecord::Migration[5.1]
  def change
    create_table :volume_citations do |t|
      t.references :volume, foreign_key: true
      t.string :last_name
      t.string :first_name
      t.string :role
      t.references :from_language_id, foreign_key: {to_table: :languages}
      t.references :to_language_id, foreign_key: {to_table: :languages}
      t.text :source_edition
      t.timestamps
    end
  end
end
