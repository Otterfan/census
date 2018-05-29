class CreateRecentSearches < ActiveRecord::Migration[5.1]
  def change
    create_table :recent_searches do |t|
      t.text :parameters
      t.text :session_id
      t.text :type

      t.timestamps
    end
  end
end
