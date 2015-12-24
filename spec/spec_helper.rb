if ENV['CIRCLECI']
  require 'rspec_junit_formatter'
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'isone'

require 'dotenv'
Dotenv.load

require 'webmock'
require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = 'spec'
  config.hook_into :webmock
  config.ignore_hosts 'codeclimate.com'
end

require 'rspec/its'
RSpec.configure do |config|
  config.around :each do |example|
    Isone.username = ENV['ISONE_USERNAME'] || 'username'
    Isone.password = ENV['ISONE_PASSWORD'] || 'password'

    example.run

    Isone.username = nil
    Isone.password = nil
  end
end