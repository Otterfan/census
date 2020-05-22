path_to_csv = File.join(File.dirname(__FILE__), "../data/authors.csv")

CSV.foreach(path_to_csv) do |row|
  parts = row[0].split(' (')

  authors = Person.where("full_name LIKE :query", query: "%#{parts[0]}%")

  if authors[0].nil?
    puts 'No result for ' + parts[0]
  else
    author = authors[0]
    author.greek_full_name = parts[1]
    if author.greek_authority.nil? && row[2] != ''
      author.greek_authority = row[2]
    end
    author.save
  end
end