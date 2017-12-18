class AddNoteToComponents < ActiveRecord::Migration[5.1]
  def change
    add_column :components, :note, :text
  end
end
