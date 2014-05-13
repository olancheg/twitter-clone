source 'https://rubygems.org'

gem 'rails', '3.2.18'
gem 'pg'
gem 'devise', '~> 2.2.8'

gem 'jquery-rails'
gem 'slim'
gem 'simple_form'
gem 'kaminari'
gem 'kaminari-bootstrap', '~> 0.1.3'

gem 'puma'

group :assets do
  gem 'bootstrap-sass', '~> 2.3.0'
  gem 'sass-rails',     '~> 3.2.3'
  gem 'coffee-rails',   '~> 3.2.1'
  gem 'uglifier',       '>= 1.0.3'
end

group :development do
  gem 'pry-rails'
  gem 'quiet_assets'
  gem 'letter_opener'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-migrate'
  gem 'terminal-notifier-guard'
end

group :test do
  gem 'ffaker'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'simplecov', '~> 0.7.1', require: false
end
