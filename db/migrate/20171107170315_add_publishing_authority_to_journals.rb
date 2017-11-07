class AddPublishingAuthorityToJournals < ActiveRecord::Migration[5.1]
  def change
    add_column :journals, :publishing_authority, :string
  end
end
