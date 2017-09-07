class AddTopicFlagToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :topic_flag, :boolean
    rename_column :people, :fist_name, :first_name
    add_index :people, :topic_flag

    reversible do |direction|
      direction.up {set_topic_authors}
    end

  end

  def set_topic_authors
    Text.all.each do |text|

      topic_author = text.topic_author
      topic_author.topic_flag = true

      name_parts = topic_author.full_name.split(', ')
      topic_author.first_name = name_parts[1]
      topic_author.last_name = name_parts[0]

      if topic_author.greek_full_name
        name_parts = topic_author.greek_full_name.split(', ')
        topic_author.greek_first_name = name_parts[1]
        topic_author.greek_last_name = name_parts[0]
      end

      years = topic_author.full_name.scan(/\d\d\d\d/)

      if years[0]
        topic_author.birth = years[0]
      end

      if years[1]
        topic_author.death = years[1]
      end

      text.topic_author.save
    end
  end

  def set_name_parts

  end

end
