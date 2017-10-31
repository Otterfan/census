class AddIssueEditorAndIssueTitleToTexts < ActiveRecord::Migration[5.1]
  def change
    add_column :texts, :issue_editor, :string
    add_column :texts, :issue_title, :string
  end
end
