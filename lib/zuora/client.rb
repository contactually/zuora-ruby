# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'nokogiri'

module Zuora
  class Client
    attr_accessor :session_token

    INSTANCE_VARIABLE_LOG_BLACKLIST = %i[@username @password].freeze

    def initialize(username, password, sandbox = true)
      @username = username
      @password = password
      @sandbox = sandbox
    end

    # Delegate SOAP methods to SOAP client
    def call!(*args)
      soap_client.call!(*args)
    end

    # Delegate REST methods to REST client
    %i[post put get delete].each do |method|
      define_method(method) do |*args|
        rest_client.send(method, *args)
      end
    end

    # Like Object.to_s, except excludes BLACKLISTed instance vars
    def to_s
      public_vars = instance_variables.reject do |var|
        INSTANCE_VARIABLE_LOG_BLACKLIST.include? var
      end

      public_vars.map! do |var|
        "#{var}=\"#{instance_variable_get(var)}\""
      end

      public_vars = public_vars.join(' ')

      "<##{self.class}:#{object_id.to_s(8)} #{public_vars}>"
    end

    alias inspect to_s

    private

    # Lazily connects SOAP / RESTS clients when needed; memoizes results
    def soap_client
      @soap_client ||= Zuora::Soap::Client.new(@username, @password, @sandbox)
    end

    def rest_client
      @rest_client ||= Zuora::Rest::Client.new(@username, @password, @sandbox)
    end
  end
end
