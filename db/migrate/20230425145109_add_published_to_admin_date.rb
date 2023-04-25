class AddPublishedToAdminDate < ActiveRecord::Migration[5.2]
  def change
    add_column :admin_news, :published, :boolean, :default => true
  end
end
