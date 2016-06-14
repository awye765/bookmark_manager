ENV['RACK_ENV'] = 'test'

# require File.join(File.dirname(__FILE__), '..', 'app.rb')
require './app/app'

require 'capybara'
require 'capybara/rspec'
require 'rspec'
require 'database_cleaner'
require 'web_helpers'

Capybara.app = BookmarkManager

RSpec.configure do |config|
  config.include Capybara::DSL
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Everything in this block runs once before all the tests run
  config.before(:suite) do
    # For Rspec?
    DatabaseCleaner.strategy = :transaction

    # For Capybara?
    DatabaseCleaner.clean_with(:truncation)
  end

  # Everything in this block runs once before each individual test
  config.before(:each) do
    DatabaseCleaner.start
  end

  # Everything in this block runs once after each individual test
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
