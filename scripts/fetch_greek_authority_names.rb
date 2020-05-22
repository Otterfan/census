require 'net/http'
require 'json'

def main
  authors = Person.where(:topic_flag => true).where.not(:viaf => nil).where.not(:viaf => '')
  authors.each do |author|
    process_author author
  end
end

# @param [Person] author
def process_author(author)
  greek_authority_name = fetch_greek_authority_name(author.viaf)

  if greek_authority_name.nil?
    puts 'No record for ' + author.viaf + ' (' + author.full_name + ')'
    return
  end

  greek_authority_name.gsub!(' )', ')')

  if author.greek_authority.nil? || author.greek_authority == ''
    author.greek_authority = greek_authority_name
  end

  authority_components = greek_authority_name.split(' (')

  if author.greek_full_name.nil?
    author.greek_full_name = authority_components[0]
  end

  name_parts = author.greek_full_name.split(', ')

  if author.greek_first_name.nil? && author.greek_last_name.nil?
    author.greek_first_name = name_parts[1]
    author.greek_last_name = name_parts[0]
  end

  puts 'Saving ' + author.viaf + ' (' + author.full_name + ')'

  author.save
end

# @param [String] uri_string
def fetch_greek_authority_name(uri_string)
  uri_string.gsub!('http:', 'https:')
  uri_string = uri_string + '/'

  puts uri_string

  uri = URI(uri_string)

  req = Net::HTTP::Get.new(uri)

  req['Accept'] = 'application/json'

  res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) { |http|
    http.request(req)
  }

  object = JSON.parse(res.body)

  greek_authority_name = nil

  if object['mainHeadings'].nil?
    return greek_authority_name
  end

  if object['mainHeadings']['data'].nil?
    return greek_authority_name
  end

  if object['mainHeadings']['data'].kind_of?(Array)
    object['mainHeadings']['data'].each do |heading|
      if heading['sources']['s'] == 'GRATEVE'
        greek_authority_name = heading['text']
      end
    end
  end

  sleep 1

  greek_authority_name

end

main