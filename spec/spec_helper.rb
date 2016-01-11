require_relative '../lib/zuora'
require 'byebug'
require 'factory_girl'
require 'rspec/mocks'

require_relative 'zuora/factories'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
end