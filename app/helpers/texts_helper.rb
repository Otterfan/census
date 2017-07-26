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
end
