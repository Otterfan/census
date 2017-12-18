class AddIsBilingualToComponent < ActiveRecord::Migration[5.1]
  def change
    add_column :components, :is_bilingual, :boolean
  end
end
