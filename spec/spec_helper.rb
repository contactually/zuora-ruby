if ENV['CIRCLECI']
  require 'rspec_junit_formatter'
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require_relative '../lib/zuora'
require 'byebug'
require 'factory_girl'
require 'rspec/mocks'

## Dotenv load environment from .env
require 'dotenv'
Dotenv.load

## VCR: Memoized HTTP request
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'zuora/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.filter_sensitive_data('<ZUORA_SANDBOX_USERNAME>') do
    ENV[' ']
  end
  c.filter_sensitive_data('<ZUORA_SANDBOX_PASSWORD>') do
    ENV['ZUORA_SANDBOX_PASSWORD']
  end
end

# FactoryGirl
FactoryGirl.definition_file_paths = ['spec/zuora/factories']
FactoryGirl.find_definitions

# RSpec configuration
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
end
