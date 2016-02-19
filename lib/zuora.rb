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
  NAMESPACES = {
    'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/',
    'xmlns:api' => 'http://api.zuora.com/',
    'xmlns:obj' => 'http://object.api.zuora.com/',
    'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
  }.freeze

  RESPONSE_NAMESPACES = NAMESPACES.merge(
    'xmlns:ns1' => 'http://api.zuora.com/',
    'xmlns:ns2' => 'http://object.api.zuora.com/'
  ).freeze
end

require_relative 'zuora/version'
require_relative 'zuora/errors'
require_relative 'zuora/utils/envelope'
require_relative 'zuora/client'
require_relative 'zuora/rest'
require_relative 'zuora/soap'
require_relative 'zuora/object'
require_relative 'zuora/dispatcher'
require_relative 'zuora/response'

require_relative 'zuora/calls/upsert'

require_relative 'zuora/calls/amend'
require_relative 'zuora/calls/create'
require_relative 'zuora/calls/delete'
require_relative 'zuora/calls/generate'
require_relative 'zuora/calls/login'
require_relative 'zuora/calls/query'
require_relative 'zuora/calls/subscribe'
require_relative 'zuora/calls/update'
