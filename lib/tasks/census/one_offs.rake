namespace :census do
  desc "Add sort pages and page spans to components and texts"
  task add_sort_pages: :environment do

    Text.where.not(page_span: '')
        .or(Text.where(page_span: nil)).each do |text|
      text.sort_page_span = extract_sort_page text.page_span
      text.save
    end

    puts " All done now!"
  end

  desc "Add sort names to citations"
  task add_sort_names_to_citations: :environment do
    TextCitation.find_each do |citation|
      citation.save
      sleep(0.1)
    end

    ComponentCitation.find_each do |citation|
      citation.save
      sleep(0.1)
    end

    VolumeCitation.find_each do |citation|
      citation.save
      sleep(0.1)
    end

    puts "All done now!"
  end

  desc "Add sort title to texts"
  task add_sort_titles_to_texts: :environment do
    Text.find_each do |text|
      text.calculate_sort_title
      text.calculate_sort_author
      puts "#{text.title} >>> #{text.sort_title}"
      puts "#{text.sort_author}"
      text.save
    end

    puts "All done now!"
  end

  desc "Set all is hidden fields to false"
  task set_is_hidden_to_false: :environment do
    Text.where.not(is_hidden: false).each do |text|
      text.is_hidden = false
      text.save
      sleep(0.1)
    end

    puts "All done now!"
  end

  desc "Set empty C or D genres to study"
  task set_no_genre_study: :environment do
    Text.where(genre: [nil, '']).where("text_type LIKE '%study%' AND (genre IS NULL OR genre ='')").each do |text|
      if text.text_type.include?('study')
        text.genre = "Study"
      end
      text.save
      sleep(0.1)
    end

    puts "All done now!"
  end

  desc "Set all 3.xxx texts to Literary History"
  task set_literary_history: :environment do
    lit_hist_section = Section.find_by(name: "Literary History")
    Text.where("section_id != #{lit_hist_section.id} AND census_id LIKE '3.%'").each do |text|
      orig_section = text.section
      text.section = lit_hist_section
      puts "#{text.census_id} : #{orig_section.name} => #{text.section.name}"
      sleep(0.1)
      text.save
    end

    puts "All done now!"
  end
end

def extract_sort_page(page_span)
  matches = page_span.match /\D*(\d+)/
  matches.nil? ? nil : matches[1].to_i
end