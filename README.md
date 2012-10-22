# Database Specification

Translate between different ways of setting up a database.

Different systems and libraries that interact with databases have different ways of saying the same thing.  Database Specification tries let them play together without repeating the connection information in multiple places.  Pick whatever format you like - ActiveRecord on Rails, `DATABASE_URL` on Heroku, and then translate it to the rest.

## Requirements

Tested on Ruby 1.9.2, with and without Rails.  It has no runtime dependencies on other gems.

## Installation

    gem install database_specification

## Usage

Initialize the DatabaseSpecification object with the appropriate constructor for the information you have, then use the appropriate accessor for the format you want.

    # Rails configured ActiveRecord, but you want to use Sequel
    ar = ActiveRecord::Base.connection_config
    Sequel.connect DatabaseSpecification.active_record(ar).url_bare

    # On Heroku, using ActiveRecord but not database.yml
    config = DatabaseSpecification.url(ENV['DATABASE_URL']).active_record
    ActiveRecord::Base.establish_connection config

    # You deploy to Heroku, and want to use DATABASE_URL for Rails locally
    # See examples/database.yml

## Author

Justin Love, [@wondible](http://twitter.com/wondible), [https://github.com/JustinLove](https://github.com/JustinLove)

## Licence

Released under the [MIT license](http://www.opensource.org/licenses/mit-license.php).
