require 'net/http'
require 'json'

def main
  puts 'Beginning'
  authors = Person.where(:topic_flag => true).where.not(:loc => nil).where.not(:loc => '').where(:loc_name => nil).where("loc LIKE '%authorities%'")
  authors.each do |author|
    process_author author
  end
end

# @param [Person] author
def process_author(author)
  loc_auth_name = fetch_loc_auth_name(author.loc)

  if loc_auth_name.nil?
    puts 'No record for ' + author.loc + ' (' + author.full_name + ')'
    return
  end

  loc_auth_name.gsub!(' )', ')')

  if author.loc_name.nil? || author.loc_name == ''
    author.loc_name = loc_auth_name
  end

  puts 'Saving ' + author.loc_name + ' (' + author.full_name + ')'

  author.save
end

# @param [String] uri_string
FULL_NAME_ELEMENT_ID = 'http://www.loc.gov/mads/rdf/v1#FullNameElement'

ELEMENT_VALUE_ID = 'http://www.loc.gov/mads/rdf/v1#elementValue'

def fetch_loc_auth_name(uri_string)
  #uri_string.gsub!('http:', 'https:')
  #uri_string = uri_string + '/'

  uri_string = uri_string + '.madsrdf.json'

  puts uri_string

  uri = URI(uri_string)

  req = Net::HTTP::Get.new(uri)

  req['Accept'] = 'application/json'

  res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => false) { |http|
    http.request(req)
  }

  object = JSON.parse(res.body)

  loc_auth_name = nil

  if object.kind_of?(Array)
    object.each do |entry|
      if entry['@type'][0] == FULL_NAME_ELEMENT_ID
        loc_auth_name = entry[ELEMENT_VALUE_ID][0]['@value']
      end
    end
  end

  sleep 1

  loc_auth_name

end

main