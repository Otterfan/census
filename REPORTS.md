# REPORTS

Reporting is built using the [Blazer](https://github.com/ankane/blazer) Rails gem.

## Installation

Installation instructions can be found on the [Blazer project repo](https://github.com/ankane/blazer#installation).

### Rails install
Be sure to install and run migrations the first time you install this gem. (Don't override `blazer.yml` when prompted!)

```
rails g blazer:install
bin/rails db:migrate RAILS_ENV=development
```

### PostgreSQL configuration

For best practices, use a read-only Postgres user account with this gem.

[Instructions:](https://github.com/ankane/blazer#postgresql)

Log into PostgreSQL

`psql -U postgres -h localhost -d census_development`

Then run the following postgres commands to create a read-only `blazer` user account:


```sql
CREATE ROLE blazer LOGIN PASSWORD 'somepassword';
GRANT CONNECT ON DATABASE census_development TO blazer;
GRANT USAGE ON SCHEMA public TO blazer;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO blazer;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO blazer;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO blazer;
```

### Environmental Variable
Next, create an environmental variable for the system user account that runs this Rails app.

```export BLAZER_DATABASE_URL=postgres://blazer:somepassword@localhost:5432/census_development```


## Run

The report interface is accessible to signed in users at [http://localhost:3000/reports](http://localhost:3000/reports)

## Sample queries

Here are a few sample queries to try in the reporting app.

* List all Text genres
  -      SELECT census_id,title,genre FROM Texts ORDER BY census_id;

* List all Text genres by genre name. This uses "Smart Variables" custom defined in the app's [blazer.yml](config/blazer.yml) config.
  -      SELECT census_id, title, genre, id as "Record link" FROM Texts WHERE genre = {genres} ORDER BY genre, census_id;
