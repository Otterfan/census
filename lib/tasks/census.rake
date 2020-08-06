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
end

def extract_sort_page(page_span)
    matches = page_span.match /\D*(\d+)/
    matches.nil? ? nil : matches[1].to_i
end