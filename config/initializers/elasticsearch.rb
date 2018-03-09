# ES host is set with an env variable
ELASTICSEARCH_URL = ENV['ELASTICSEARCH_URL'] || 'http://localhost:9200'
Elasticsearch::Model.client = Elasticsearch::Client.new host: ELASTICSEARCH_URL