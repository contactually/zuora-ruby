# frozen_string_literal: true

if ENV['CIRCLECI']
  require 'rspec_junit_formatter'
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require_relative '../lib/zuora'

require 'byebug'
require 'factory_girl'
require 'rspec/mocks'
require 'faker'

## Dotenv load environment from .env
require 'dotenv'
Dotenv.load

## VCR: Memoized HTTP request
require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock # or :fakeweb
  c.filter_sensitive_data('<ZUORA_SANDBOX_USERNAME>') do
    ENV['ZUORA_SANDBOX_USERNAME']
  end
  c.filter_sensitive_data('<ZUORA_SANDBOX_PASSWORD>') do
    ENV['ZUORA_SANDBOX_PASSWORD']
  end
  c.ignore_hosts 'codeclimate.com'
end

# FactoryBot
FactoryBot.definition_file_paths = ['spec/factories']
FactoryBot.find_definitions

# RSpec configuration
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.before(:each) do
    unless %w[ZUORA_SANDBOX_USERNAME ZUORA_SANDBOX_PASSWORD].all? { |k| ENV[k] }
      raise 'Please set ZUORA_SANDBOX_USERNAME and ZUORA_SANDBOX_PASSWORD'
    end
  end
end
