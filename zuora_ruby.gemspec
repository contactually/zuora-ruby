# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zuora/version'

Gem::Specification.new do |spec|
  spec.name = 'zuora-ruby'
  spec.version = Zuora::VERSION
  spec.authors = ['Contactually Engineering']
  spec.email = ['engineering@contactually.com']

  spec.summary = 'A Ruby wrapper for Zuora API.'
  spec.description = 'A Ruby wrapper for Zuora API.'
  spec.homepage = 'https://github.com/contactually/zuora-ruby'
  spec.license = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to prevent public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Runtime
  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'dotenv'
  spec.add_runtime_dependency 'faraday'
  spec.add_runtime_dependency 'faraday_middleware'
  spec.add_runtime_dependency 'hashie', '~> 3.4'
  spec.add_runtime_dependency 'nokogiri', '~> 1.6'

  # Development
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'factory_bot'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'rspec_junit_formatter', '0.2.2'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock', '~> 1.22'
end
