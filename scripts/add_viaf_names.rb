require 'faraday'
require 'json'

puts Faraday::VERSION

def format_viaf_name(viaf_name)
  viaf_name.gsub(/,? ?\(?\d\d\d\d-?\d*\)?/, '').gsub('/, *\z/', '').strip
end

def fetch_viaf(conn, url)
  puts url
  res = conn.get(url)
  json = res.body
  sleep(0.5)
  JSON.parse(json)
end

def add_viaf_names(conn, person)
  alt_names = []
  url = person.viaf.tr('http', 'https') + '/'
  viaf_response = fetch_viaf(conn, url)

  if viaf_response['ns0:redirect']
    url = 'https://viaf.org/viaf/' + viaf_response['ns0:redirect']['ns0:directto'] + '/'
    viaf_response = fetch_viaf(conn, url)
  end

  if viaf_response['ns1:mainHeadings']['ns1:data'].kind_of?(Array)
    viaf_response['ns1:mainHeadings']['ns1:data'].each do |entry|
      name = format_viaf_name(entry['ns1:text'])
      alt_names |= [name]
    end
  else
    name = format_viaf_name(viaf_response['ns1:mainHeadings']['ns1:data']['ns1:text'])
    alt_names |= [name]
  end
  alt_names
end

conn = Faraday.new
conn.headers = {'Accept' => 'application/json'}

Person.where(topic_flag: true).each do |person|
  alt_names = []

  unless person.viaf.in? [nil, '']
    alt_names = add_viaf_names(conn, person)
  end

  person.texts.each do |text|
    if text.authors_name_from_source
      name = text.authors_name_from_source.strip
      alt_names |= [name]
    end
  end
  alt_names.uniq!
  person.alternate_name = alt_names.join "\n"
  puts person.alternate_name
  person.save
end

