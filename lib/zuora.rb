# encoding: utf-8

# Dependencies
require 'faraday'
require 'json'
require 'active_support'
require 'active_support/core_ext/string'

module Zuora
  API_URL = 'https://api.zuora.com/rest/v1/'.freeze
  SANDBOX_URL = 'https://apisandbox-api.zuora.com/rest/v1/'.freeze
end

require_relative 'utils/composite_types'
require_relative 'utils/schema_model'

require_relative 'zuora/version'
require_relative 'zuora/client'
require_relative 'zuora/soap_client'
require_relative 'zuora/models'
