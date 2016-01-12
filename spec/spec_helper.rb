if ENV['CIRCLECI']
  require 'rspec_junit_formatter'
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require_relative '../lib/zuora'
require 'byebug'
require 'factory_girl'
require 'rspec/mocks'

require 'dotenv'
Dotenv.load

FactoryGirl.definition_file_paths = ['spec/zuora/factories']
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
end
