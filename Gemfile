source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'haml'
gem 'simple_form'
gem 'htmlentities'
gem 'nokogiri'
gem 'carrierwave'
gem "fog", "~> 1.3.1"


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem "therubyracer"
  gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
  gem "twitter-bootstrap-rails"

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'faker'

group :test do
  gem 'shoulda-matchers'
  gem 'webmock'  
  gem 'vcr'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'capybara'
  gem "factory_girl_rails", "~> 4.0"
end
  
group :development, :test do
  gem "rspec-rails", "~> 2.0"  
  gem 'spork', '~> 1.0rc'  
  gem 'poltergeist'
  gem 'guard-livereload'  
  gem 'guard-jasmine'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'jasminerice'
  gem 'timecop', :git => 'git://github.com/travisjeffery/timecop.git'
  gem 'dotenv'
  
  
  # Note: poltergeist and guard-jasmine requires phantomjs, 
  # install with homebrew on osx: "brew install phantomjs"
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
