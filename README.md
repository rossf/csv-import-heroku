# csv-import-heroku
Import a CSV into a database and provide versioning information. Trying out Heroku.

## Project setup
This project requires PostgreSQL. Download it from [here](https://www.postgresql.org/download/).

To get started clone the project and run `bundle install`.

Create the database with `bundle exec rails db:migrate`.

To start the server run `bundle exec rails s`.

Tests are run using `bundle exec rspec`.

## Usage
A version of this application is deployed at https://morning-reef-74582.herokuapp.com/

It allows users to import a CSV file and then query a database for the imported data.

Query an entry by passing in the object_type and object_id for the current version of the object:
https://morning-reef-74582.herokuapp.com/csv_objects?object_id=1&object_type=Order

You can optionally also pass in a timestamp to get the version at that time:
https://morning-reef-74582.herokuapp.com/csv_objects?object_id=1&object_type=Order&timestamp=1484730554

# CSV format
The input CSV may or may not have a header row. If it does not have a header row it is expected to have this format:
`object_id,object_type,timestamp,object_changes`

If a header row is provided the importer will use that header row as the data format. The names of the columns are expected to be the same as those listed but the order may be changed.
