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

require_relative 'zuora/version'

module Zuora
  NAMESPACES = {
    'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/',
    'xmlns:ns1' => 'http://api.zuora.com/',
    'xmlns:ns2' => 'http://object.api.zuora.com/',
    'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
  }.freeze
end

require_relative 'zuora/utils/envelope'
require_relative 'zuora/client'
require_relative 'zuora/object'
require_relative 'zuora/calls/login'
require_relative 'zuora/calls/subscribe'
require_relative 'zuora/calls/create'
