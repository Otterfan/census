require 'csv'
ActiveRecord::Base.logger.silence do

  authors_file = "./Reconciled-Author-Names.csv"
  journals_file = './journals-issn.csv'

  sql = "SELECT * FROM people WHERE people.full_name LIKE 'Achilleos'"

  CSV.foreach(authors_file) do |row|
    authors = Person.where('full_name LIKE ? AND topic_flag = true', "%#{row[4]}%")
    if !authors.empty?
      authors[0].viaf = row[3]
      authors[0].loc = row[1]
      authors[0].save
    else
      author = Person.new
      author.full_name = row[4]

      name_parts = row[4].split(', ')
      author.first_name = name_parts[1]
      author.last_name = name_parts[0]

      author.viaf = row[3]
      author.loc = row[1]

      author.topic_flag = true

      if row[5]
        dates = row[5].split('-')

        if dates[0]
          author.birth = dates[0].sub('b. ', '')
        end

        if dates[1]
          author.death = dates[1]
        end
      end

      if row[6]
        author.domicile = row[6]
      end

      author.save
    end
  end

  CSV.foreach(journals_file) do |row|
    journals = Journal.where('title = ?', row[0])
    if !journals.empty?
      journals[0].issn = row[3]
      journals[0].indexed_range=row[2]
      journals[0].save
    else
      journal = Journal.new
      journal.title = row[0]
      journal.issn = row[3]
      journal.indexed_range = row[2]

      possible_places = Place.where('name LIKE ?', "#{row[1]}")
      if possible_places[0]
        journal.place = possible_places[0]
      end

      journal.sort_title = row[0].sub(/^The +/, '').sub(/^An +/, '').sub(/^A +/, '')

      journal.save
    end
  end
end