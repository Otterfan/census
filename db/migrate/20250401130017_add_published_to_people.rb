class AddPublishedToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :published, :boolean, default: true
  end
end
