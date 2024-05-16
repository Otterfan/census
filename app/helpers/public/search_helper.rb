module Public::SearchHelper

  def filter_search_citations_by_role(text_citations, role)
    filtered = []
    text_citations.each do |citation|
      if citation.role === role
        filtered.push(citation.controlled_name)
      end
    end
    filtered.join('; ')
  end

  def performers_from_search(text_citations)
    filter_search_citations_by_role(text_citations, 'performer')
  end

  def translators_from_search(text_citations)
    filter_search_citations_by_role(text_citations, 'translator')
  end

  def editors_from_search(text_citations)
    filter_search_citations_by_role(text_citations, 'editor')
  end

  def texts_to_mappable(texts)
    rows = []
    texts.each do |text|
      text.publication_places.each do |place|
        next if place.place.latitude == ''
        display_text = render partial: 'shared/map_tombstone', locals: { text: text }
        display_text.gsub!("\n", "")
        display_text.gsub!('"', '&quot;')
        new_row = "[#{place.place.latitude},#{place.place.longitude},\"#{display_text}\"]"
        rows.append(new_row)
      end
    end
    rows
  end

  def additional_responsibilities_from_search(text_citations)
    editors = []
    translators = []
    text_citations.each do |citation|
      if citation.role === 'translator'
        translators.push(citation.controlled_name + ' (translator)')
      end

      if citation.role === 'editor'
        editors.push(citation.controlled_name + ' (editor)')
      end
    end
    names = translators + editors
    names.join('; ')
  end
end
