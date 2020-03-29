class AddHiddenToTexts < ActiveRecord::Migration[5.2]
  def change
    add_column :texts, :is_hidden, :boolean, default: false
  end
end
