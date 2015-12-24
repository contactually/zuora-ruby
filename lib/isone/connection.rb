# encoding: utf-8
require 'faraday'

module Isone
  # Initializes a connection to ISO NE's API.  Any specific route should be
  # specified in the classes that use the Connection class.
  class Connection
    attr_accessor :connection

    class << self
      # Create instances of connection object to ensure thread safety
      # @return [Faraday] connection
      def connection
        new.connection
      end
    end

    def initialize
      connection = Faraday.new(url: Isone::API_URL, ssl: { verify: false })
      connection.basic_auth(Isone.username, Isone.password)
      @connection = connection
    end
  end
end
