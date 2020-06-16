class AddSectionsToComponents < ActiveRecord::Migration[5.2]
  def change
    add_column :components, :section, :text
    add_column :components, :subsection, :text
  end
end
