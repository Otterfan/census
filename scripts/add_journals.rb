titles = Text.select(:journal_title).distinct.map(&:journal_title)

titles.each do |title|
  if title
    sort_title = title.sub(/^The +/, '').sub(/^An +/, '').sub(/^A +/, '')
    journal = Journal.create(title: title, sort_title: sort_title)
    Text.where('journal_title = ?', title).update_all(journal_id: journal.id)
  end
end