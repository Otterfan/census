# README

## System dependencies

### Java 8

Elasticsearch requires Java version 8.

Be sure the `JAVA_HOME` environmental variable is set.

### Elasticsearch

#### Install

Install the most recent [Elasticsearch](https://www.elastic.co/) 6.x version through the official package installer or through the local system package manager, e.g., [brew](http://brewformulas.org/Elasticsearch), [rpm](https://www.elastic.co/guide/en/elasticsearch/reference/6.2/rpm.html), [apt-get](https://www.elastic.co/guide/en/elasticsearch/reference/6.2/deb.html).


Check that Elasticsearch is running -- <localhost:9200>.

#### Import

Run the following Rake command to delete, create and index all Text model records (this may take a few minutes depending on the total number of records):

```bundle exec rake environment elasticsearch:import:model CLASS='Text' FORCE=y```

To see all rake commands for Elasticsearch run this command:

```bundle exec rake -D elasticsearch```

#### Test import

To check that the import ran successfully:
* check schema: <localhost:9200/texts>
* check first record: <localhost:9200/texts/text/1>

#### Secure

Consider blocking public access to port 9200 on the server running Elasticsearch.
