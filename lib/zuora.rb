# encoding: utf-8

# Dependencies
require 'faraday'
require 'json'
require 'active_support'
require 'active_support/core_ext/string'
require 'hashie'

module Zuora
  API_URL = 'https://api.zuora.com/rest/v1/'.freeze
  SANDBOX_URL = 'https://apisandbox-api.zuora.com/rest/v1/'.freeze
end

require_relative 'utils/schema_model'

require_relative 'zuora/version'
require_relative 'zuora/client'
require_relative 'zuora/models'

module Zuora
  module Soap
    NAMESPACES = {
      'xmlns:soapenv' => 'http://schemas.xmlsoap.org/spec/envelope/',
      'xmlns:ns1' => 'http://api.zuora.com/',
      'xmlns:ns2' => 'http://object.api.zuora.com/',
      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
    }.freeze
  end
end

require_relative 'zuora/soap/utils/envelope'
require_relative 'zuora/soap/client'
require_relative 'zuora/soap/object'
require_relative 'zuora/soap/calls/login'
require_relative 'zuora/soap/calls/subscribe'
require_relative 'zuora/soap/calls/create'
