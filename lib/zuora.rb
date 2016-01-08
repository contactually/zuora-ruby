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

  STATE_ABBREVIATIONS = %w(AA AE AP AK AL AR AZ CA CO CT DC DE FL
                           GA GU HI IA ID IL IN KS KY LA MA MD ME
                           MI MN MO MS MT NC ND NE NH NJ NM NV NY
                           OH OK OR PA PR RI SC SD TN TX UT VA VI
                           VT WA WI WV WY)
end

# Models for Validations and Serialization
require_relative 'zuora/account'
require_relative 'zuora/card_holder'
require_relative 'zuora/contact'
require_relative 'zuora/payment_method'

