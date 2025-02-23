# frozen_string_literal: true

source 'https://rubygems.org'
# git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.2'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# A Ruby wrapper for the Hacker News API
gem 'hn_api', '~> 0.0.2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger
  # console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Brings the RSpec testing framework to Ruby on Rails as a drop-in alternative
  # to its default testing framework, Minitest.
  gem 'rspec-rails', '~> 4.0'

  # Combine 'pry' with 'byebug'. Adds 'step', 'next', 'finish', 'continue' and
  # 'break' commands to control execution.
  gem 'pry-byebug', '~> 3.9'

  # Record your test suite's HTTP interactions and replay them during future
  # test runs for fast, deterministic, accurate tests.
  gem 'vcr', '~> 5.1'

  # WebMock allows stubbing HTTP requests and setting expectations on HTTP
  # requests.
  gem 'webmock', '~> 3.8', '>= 3.8.3'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Access an interactive console on exception pages or by calling 'console'
  # anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
