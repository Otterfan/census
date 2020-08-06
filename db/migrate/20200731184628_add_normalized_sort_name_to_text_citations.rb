class AddNormalizedSortNameToTextCitations < ActiveRecord::Migration[5.2]
  def change
    add_column :text_citations, :sort_name, :string
    add_index :text_citations, :sort_name

    add_column :component_citations, :sort_name, :string
    add_index :component_citations, :sort_name

    add_column :volume_citations, :sort_name, :string
    add_index :volume_citations, :sort_name
  end
end