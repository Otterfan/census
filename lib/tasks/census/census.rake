namespace :census do
  desc "Touch all text records"
  task save_all_records: :environment do
    Text.find_each do |text|
      text.save
      sleep(0.1)
    end
  end

  desc "Touch all people records"
  task save_all_people: :environment do
    Person.find_each do |person|
      puts "Saving #{person.id}..."
      person.save
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

    TextCitation.where("name LIKE :suffix", suffix: "% ")
                .or(TextCitation.where("name LIKE :prefix", prefix: " %"))
                .each do |cite|
      puts "Stripping #{cite.name}"
      cite.name = cite.name.strip
      cite.save
    end

    TextCitation.where("first_name LIKE :suffix", suffix: "% ")
                .or(TextCitation.where("first_name LIKE :prefix", prefix: " %"))
                .each do |cite|
      puts "Stripping #{cite.first_name}"
      cite.first_name = cite.first_name.strip
      cite.save
    end

    TextCitation.where("last_name LIKE :suffix", suffix: "% ")
                .or(TextCitation.where("last_name LIKE :prefix", prefix: " %"))
                .each do |cite|
      puts "Stripping #{cite.last_name}"
      cite.last_name = cite.last_name.strip
      cite.save
    end

    ComponentCitation.where("controlled_name LIKE :suffix", suffix: "% ")
                     .or(ComponentCitation.where("controlled_name LIKE :prefix", prefix: " %"))
                     .each do |cite|
      puts "Stripping #{cite.controlled_name}"
      cite.controlled_name = cite.controlled_name.strip
      cite.save
    end

    ComponentCitation.where("name LIKE :suffix", suffix: "% ")
                     .or(ComponentCitation.where("name LIKE :prefix", prefix: " %"))
                     .each do |cite|
      puts "Stripping #{cite.name}"
      cite.name = cite.name.strip
      cite.save
    end

    ComponentCitation.where("first_name LIKE :suffix", suffix: "% ")
                     .or(ComponentCitation.where("first_name LIKE :prefix", prefix: " %"))
                     .each do |cite|
      puts "Stripping #{cite.first_name}"
      cite.first_name = cite.first_name.strip
      cite.save
    end

    ComponentCitation.where("last_name LIKE :suffix", suffix: "% ")
                     .or(ComponentCitation.where("last_name LIKE :prefix", prefix: " %"))
                     .each do |cite|
      puts "Stripping #{cite.last_name}"
      cite.last_name = cite.last_name.strip
      cite.save
    end

    VolumeCitation.find_each do |cite|
      if cite.controlled_name
        cite.controlled_name = cite.controlled_name.strip
      end

      if cite.name
        cite.name = cite.name.strip
      end

      if cite.last_name
        cite.last_name = cite.last_name.strip
      end

      if cite.first_name
        cite.first_name = cite.first_name.strip
      end

      cite.save
    end

    puts "All done now!"
  end
end