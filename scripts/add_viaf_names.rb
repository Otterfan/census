require 'faraday'
require 'json'

puts Faraday::VERSION

def format_viaf_name(viaf_name)
  viaf_name.tr('0-9', '').tr('-', '').tr(',', ' ')
end

def fetch_viaf(conn, url)
  puts url
  res = conn.get(url)
  json = res.body
  JSON.parse(json)
end

def add_viaf_names(conn, person)
  puts person.full_name
  alternate_name = ''
  url = person.viaf.tr('http', 'https') + '/'
  viaf_response = fetch_viaf(conn, url)

  if viaf_response['ns0:redirect']
    url = 'https://viaf.org/viaf/' + viaf_response['ns0:redirect']['ns0:directto'] + '/'
    viaf_response = fetch_viaf(conn, url)
  end

  if viaf_response['ns1:mainHeadings']['ns1:data'].kind_of?(Array)
    viaf_response['ns1:mainHeadings']['ns1:data'].each do |entry|
      alternate_name << ' ' << format_viaf_name(entry['ns1:text'])
    end
  else
    alternate_name = format_viaf_name(viaf_response['ns1:mainHeadings']['ns1:data']['ns1:text'])
  end
  alternate_name
end

conn = Faraday.new
conn.headers = {'Accept' => 'application/json'}

Person.where.not(viaf: [nil, '']).find_each do |person|
  person.alternate_name = add_viaf_names(conn, person)
  puts person.alternate_name
  person.save
  sleep(0.5)
end

