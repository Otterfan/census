namespace :census do
  desc "Migrate single URLs to multi-value fields"
  task migrate_urls: :environment do

    Text.where.not(url: [nil, ""]).each do |text|
      url = Url.new
      url.value=text.url
      url.accessed_on = text.accessed_on
      text.urls << url
      puts "Added #{text.url}"
    end

    puts "All done now!"
  end
end