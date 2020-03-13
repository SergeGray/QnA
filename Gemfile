source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'rails', '~> 6.0.2', '>= 6.0.2.1'

gem 'active_model_serializers', '~> 0.10.0'
gem 'aws-sdk-s3', require: false
gem 'bootsnap', '>= 1.4.2', require: false
gem 'cancancan'
gem 'cocoon'
gem 'devise'
gem 'doorkeeper'
gem 'gon'
gem 'jbuilder', '~> 2.7'
gem 'jquery-rails'
gem 'mysql2'
gem 'oj'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-vkontakte'
gem 'pg'
gem 'puma', '~> 4.3'
gem 'sass-rails', '>= 6'
gem 'sidekiq', '< 6'
gem 'sinatra', require: false
gem 'slim-rails'
gem 'sqlite3', '~> 1.4'
gem 'thinking-sphinx'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'
gem 'whenever', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'letter_opener'
  gem 'rspec-rails', '~> 4.0.0.beta3'
end

group :development do
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'capybara-email'
  gem 'database_cleaner-active_record'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
