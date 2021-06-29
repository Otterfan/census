namespace :census do
  desc "Touch all records"
  task save_all_records: :environment do
    Text.find_each do |text|
      text.save
      sleep(0.1)
    end
  end

  desc "Strip whitespaces from citations"
  task strip_citation_whitespace: :environment do

    TextCitation.where("controlled_name LIKE :suffix", suffix: "% ")
        .or(TextCitation.where("controlled_name LIKE :prefix", prefix: " %"))
        .each do |cite|
      puts "Stripping #{cite.controlled_name}"
      cite.controlled_name = cite.controlled_name.strip
      cite.save
    end

    ComponentCitation.where("controlled_name LIKE :suffix", suffix: "% ")
        .or(ComponentCitation.where("controlled_name LIKE :prefix", prefix: " %"))
        .each do |cite|
      puts "Stripping #{cite.controlled_name}"
      cite.controlled_name = cite.controlled_name.strip
      cite.save
    end

    puts "All done now!"
  end
end