class AddControlledNameToTextCitations < ActiveRecord::Migration[5.1]
  def up
    add_column :text_citations, :controlled_name, :text
    add_column :component_citations, :controlled_name, :text
    add_column :volume_citations, :name, :text
    add_column :volume_citations, :controlled_name, :text

    TextCitation.find_each do |citation|
      set_controlled_name citation
    end

    ComponentCitation.find_each do |citation|
      set_controlled_name citation
    end

    VolumeCitation.find_each do |citation|
      citation.name = "#{citation.last_name}, #{citation.first_name}"
      set_controlled_name citation
    end

  end

  def down
    remove_column :text_citations, :controlled_name
    remove_column :component_citations, :controlled_name
    remove_column :volume_citations, :controlled_name
    remove_column :volume_citations, :name
  end

  def set_controlled_name(citation)
    citation.name.strip!
    citation.name.gsub(/  +/, ' ')
    citation.controlled_name = citation.name
    citation.save!
  end
end
