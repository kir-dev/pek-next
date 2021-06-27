source 'https://rubygems.org'

ruby '2.5.7'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3.6'
# Use pg as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 3.2.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Use omniauth for oauth implementation
gem 'omniauth'
gem 'omniauth-oauth2'
# Use sidekiq for background workers
gem 'sidekiq'
gem 'sidekiq-cron'
# Use draper for decorating models
gem 'draper'
# Use kaminari for pagination
gem 'kaminari'
# Use puma for application server
gem 'puma'
# Use rollbar for live error tracking
gem 'rollbar'
# Use em-http-request for async requests and eventmachine
gem 'em-http-request'
# Use pdfkit for PDF generation
gem 'pdfkit'
# Use wkhtmltopdf-binary to easily reach wkhtmltopdf
gem 'wkhtmltopdf-binary', '~> 0.12.3.0'
# Use render_anywhere for rendering template anywhere
gem 'render_anywhere'
# Use dotenv for environment variables
gem 'dotenv-rails'
# Use exceprion_handler for nice error pages
gem 'exception_handler', '~> 0.8.0.0'
# Use unsplash for nice pictures
gem 'unsplash'
# use activity_notification as notification system
gem 'activity_notification', '~> 2.2', '>= 2.2.1'
# use Pundit for authorization
gem 'pundit', '~> 2.1'
gem "bootsnap", ">= 1.1.0", require: false
gem 'listen'
# use jbuilder to provide data for the REST API
gem 'jbuilder', '~> 2.11', '>= 2.11.2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Brakeman: security tool
  gem 'brakeman', require: false
  # RSpec for more modern testing
  gem 'rspec-rails', '~> 5.0'
end

group :test do
  gem 'database_cleaner-active_record'
  # Factory Bot for creating factories for tests
  gem 'factory_bot_rails'

  gem 'minitest', '~> 5.10.0'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'pundit-matchers', '~> 1.6'
end

group :development do
  gem 'annotate'
  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'

  gem 'better_errors'
  gem 'binding_of_caller'
end
