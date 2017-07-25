class AddSeriesToTexts < ActiveRecord::Migration[5.1]
  def change
    add_column :texts, :series, :string
  end
end
