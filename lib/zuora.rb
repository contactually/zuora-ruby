# encoding: utf-8

# Dependencies
require 'faraday'
require 'json'
require 'active_model'
require 'active_support/all'

# Zuora classes
require_relative 'zuora/version'
require_relative 'zuora/client'

module Zuora
  API_URL = 'https://webservices.iso-ne.com/api/v1.1'
  SANDBOX_URL = 'https://apisandbox-api.zuora.com/rest/v1'
end