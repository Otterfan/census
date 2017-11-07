class AddSeenInPersonToTexts < ActiveRecord::Migration[5.1]
  def change
    add_column :texts, :seen_in_person, :boolean
  end
end
