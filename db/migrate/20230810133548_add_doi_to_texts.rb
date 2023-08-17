class AddDoiToTexts < ActiveRecord::Migration[5.2]
  def change
    add_column :texts, :doi, :string
  end
end
