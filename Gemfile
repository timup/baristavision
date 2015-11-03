source "https://rubygems.org"

ruby "2.2.3"

gem "bootstrap-sass", "~> 3.3.5"
gem "date_validator"
gem "delayed_job_active_record"
gem "devise"
gem "email_validator"
gem "fog"
gem "font-awesome-rails"
gem "high_voltage"
gem "i18n-tasks"
gem "jquery-rails"
gem "jquery-tablesorter"
gem "mini_magick"
gem "normalize-rails", "~> 3.0.0"
gem "pg"
gem "puma"
gem "rack-canonical-host"
gem "rails", "4.2.4"
gem "rails-erd"
gem "sass-rails", "~> 5.0"
gem "simple_form"
gem "sitemap_generator"
gem "uglifier"
gem "validates_formatting_of"
gem "will_paginate"

group :development do
  gem "byebug"
  gem "pry"
  gem "pry-byebug"
  gem "spring"
  gem "spring-commands-rspec"
  gem "web-console"
end

group :development, :test do
  gem "awesome_print"
  gem "bundler-audit", require: false
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "faker"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.3"
end

group :test do
  gem "capybara-webkit", ">= 1.2.0"
  gem "database_cleaner"
  gem "formulaic"
  gem "launchy"
  gem "shoulda-matchers", require: false
  gem "simplecov", require: false
  gem "timecop"
end

group :staging, :production do
  gem "rails_stdout_logging"
  gem "rack-timeout"
end