require_relative '../lib/zuora'
require 'byebug'
require 'factory_girl'
require 'rspec/mocks'

FactoryGirl.definition_file_paths = ['spec/zuora/factories']
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
end