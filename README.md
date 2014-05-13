# Yet Another Twitter Clone

## Prerequisites
* PostgreSQL
* Ruby 1.9+
* PhantomJS (optional)

## Installation
* Adjust `config/database.yml`
* Run `bundle install`
* Create databases `bundle exec rake db:create:all`
* Run migrations `bundle exec rake db:migrate`
* Populate DB with fake data `bundle exec rake db:seed`
* Run server `rails server`
* Run specs `bundle exec rake`

## TODO
* add more capybara specs
