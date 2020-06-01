module Public::SearchHelper
  def translators_from_search(text_citations)
    translators = []
    text_citations.each do |citation|
      if citation.role === 'translator'
        translators.push(citation.controlled_name + ' (tr.)')
      end
    end
    translators.join('; ')
  end

  def editors_from_search(text_citations)
    editors = []
    text_citations.each do |citation|
      if citation.role === 'editor'
        editors.push(citation.controlled_name + ' (ed.)')
      end
    end
    editors.join('; ')
  end

  def additional_responsibilities_from_search(text_citations)
    editors = []
    translators = []
    text_citations.each do |citation|
      if citation.role === 'translator'
        translators.push(citation.controlled_name + ' (tr.)')
      end

      if citation.role === 'editor'
        editors.push(citation.controlled_name + ' (ed.)')
      end
    end
    names = translators + editors
    names.join('; ')
  end
end
