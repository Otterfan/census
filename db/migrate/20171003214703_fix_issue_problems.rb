class FixIssueProblems < ActiveRecord::Migration[5.1]
  def change
    rename_column :texts, :parent_issue, :issue_number
    add_column :texts, :issue_volume, :string
    add_column :texts, :issue_season_month, :string
  end
end
