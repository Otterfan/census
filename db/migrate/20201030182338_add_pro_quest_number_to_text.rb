class AddProQuestNumberToText < ActiveRecord::Migration[5.2]
  def change
    add_column :texts, :proquest_num, :string
  end
end
