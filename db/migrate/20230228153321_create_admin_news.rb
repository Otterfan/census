class CreateAdminNews < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_news do |t|
      t.text :brief_content
      t.text :content
      t.text :note
      t.date :posted_on

      t.timestamps
    end
  end
end
