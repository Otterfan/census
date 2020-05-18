module TextsHelper
  def texts_by_author(texts)
    if texts[0].topic_author
      heading = texts[0].topic_author.full_name
    else
      heading = 'Literary Histories'
    end

    authors = []
    author_group = {
        :author => heading,
        :texts => []
    }

    texts.each do |text|
      heading = text.topic_author.nil? ? 'Literary Histories' : text.topic_author.full_name

      unless heading == author_group[:author]
        puts text.topic_author
        authors.push(author_group)
        author_group = {
            :author => heading,
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

  # HACK should be able to pull nested Language relationships automatically
  # TODO remove where model method from view helper - place in controller or model
  def get_lang_from_id(lang_id)
    if lang_id.is_a? Integer
      Language.where(:id => lang_id).first
    else
      nil
    end
  end
end
