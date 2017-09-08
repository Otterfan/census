class AddIsIllustratedToTexts < ActiveRecord::Migration[5.1]
  def change
    add_column :texts, :is_illustrated, :boolean
  end
end
