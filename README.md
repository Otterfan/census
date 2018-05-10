# README

## System dependencies

### Java 8

Elasticsearch requires Java version 8.

Be sure the `JAVA_HOME` environmental variable is set in the user's environment.

### Elasticsearch

Elasticsearch is the search index backend for full-text search.

#### Install

Install the most recent [Elasticsearch](https://www.elastic.co/) 6.x version through the official package installer or through the local system package manager, 
e.g., [brew](http://brewformulas.org/Elasticsearch), 
[rpm](https://www.elastic.co/guide/en/elasticsearch/reference/6.2/rpm.html), 
[apt](https://www.elastic.co/guide/en/elasticsearch/reference/6.2/deb.html).

#### Run

Start Elasticsearch manually:

`./bin/elasticsearch`, or `elasticsearch`

or as a system service.

Check that Elasticsearch is running on the default port -- [http://localhost:9200](http://localhost:9200).

#### Install ICU Analysis plugin

The following plugin adds extended Unicode support for foreign language analysis.

Be sure to shut off Elasticsearch before installing this plugin. Run:

```sudo bin/elasticsearch-plugin install analysis-icu```

[More documentation.](https://www.elastic.co/guide/en/elasticsearch/plugins/current/analysis-icu.html)


#### Import

Run the following Rake command to delete, create and index all Text model records (this may take a few minutes depending on the total number of records):

```bundle exec rake environment elasticsearch:import:model CLASS='Text' FORCE=y```

To see all rake commands for Elasticsearch run this command:

```bundle exec rake -D elasticsearch```

#### Test import

To check that the import ran successfully:
* check schema: [http://localhost:9200/texts](http://localhost:9200/texts)
* check first record: [http://localhost:9200/texts/text/1](http://localhost:9200/texts/text/1)

### Redis

Redis is used for ElasticSearch index job queueing. 

#### Install

Install the most recent [Redis](https://www.redis.io/) 4.0.x version through the official [source](https://redis.io/topics/quickstart) or through the local system package manager, e.g., [brew](http://brewformulas.org/Redis), [rpm/apt](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-redis).

Make note of where the Redis config file is stored. Brew may store this file at `/usr/local/etc/redis.conf`. 
Other package managers may store this file at `/etc/redis/6379.conf` or similar locations.

#### Update config

To improve security we'll bind Redis to listen only to localhost. Open the Redis config file for editing and make sure this setting line is uncommented:
`bind 127.0.0.1`

#### Run

Start Redis manually:

`redis-server /path/to/redis.conf`

or as a system service.

Check that Redis is running on the default port -- [http://localhost:6379](http://localhost:6379).

### Sidekiq

[Sidekiq](https://github.com/mperham/sidekiq) is a Ruby gem for managing background jobs. It connects with Redis to manage the job queue.

This gem should automatically get installed when the application is installed. 

#### Config

Sidekiq is configured to run with the default configuration settings. If Redis is running on non-default ports then those settings can be changed in the [sidekiq.rb](../blob/sidekiq/config/initializers/sidekiq.rb) initializer file. 

#### Run

It does require a separate Rails process to be run:

`bundle exec sidekiq -L log/sidekiq.log`

### Security

Consider blocking public access to default ports:
* `9200` for Elasticsearch,
* `6379` for Redis.
