# TODO: Only load development dependencies in development
require 'byebug'
require 'pp'

# Dependencies
require 'faraday'
require 'json'
require 'active_model'
require 'active_support/all'

# Isone classes
require 'isone/version'
require 'isone/connection'
require 'isone/lmp'
require 'isone/location'
require 'isone/five_min_lmp'

module Isone
  API_URL = 'https://webservices.iso-ne.com/api/v1.1/'

  # @param [String] key
  def self.username=(username)
    @username = username
  end

  # @return [String]
  def self.username
    @username
  end

  def self.password=(password)
    @password = password
  end

  def self.password
    @password
  end
end
