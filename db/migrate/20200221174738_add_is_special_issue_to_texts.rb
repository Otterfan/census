class AddIsSpecialIssueToTexts < ActiveRecord::Migration[5.2]
  def change
    add_column :texts, :is_special_issue, :boolean
  end
end
