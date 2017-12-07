class AddDaiToTexts < ActiveRecord::Migration[5.1]
  def change
    add_column :texts, :dai, :string
  end
end
