module TextsHelper
  def texts_by_author(texts)
    authors = []
    author_group = {
        :author => texts[0].topic_author.full_name,
        :texts => []
    }

    texts.each do |text|
      unless text.topic_author.full_name == author_group[:author]
        authors.push(author_group)
        author_group = {
            :author => text.topic_author.full_name,
            :texts => []
        }
      end
      author_group[:texts].push(text)
    end
    authors.push(author_group)
  end

  def topic_authors
    topic_authors = []
    Person.where(topic_flag: true).each do |person|
      topic_authors.push([person.full_name, person.id])
    end
    topic_authors
  end

  def journals
    journals = []
    Journal.limit(1000).each do |journal|
      journals.push([journal.title, journal.id])
    end
    journals
  end

  # HACK remove find_by model method from view helper
  def get_lang_name_from_id(lang_id)
    if lang_id.is_a? Integer
      Language.find_by(:id => lang_id).name
    else
      nil
    end
  end
end
