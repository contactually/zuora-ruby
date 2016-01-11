# encoding: utf-8

# Dependencies
require 'faraday'
require 'json'
require 'active_model'
require 'active_model_serializers'
require 'active_support'

module Zuora
  API_URL = 'https://api.zuora.com/rest/v1/'
  SANDBOX_URL = 'https://apisandbox-api.zuora.com/rest/v1/'

  STATE_ABBREVIATIONS = %w(AA AE AP AK AL AR AZ CA CO CT DC DE FL
                           GA GU HI IA ID IL IN KS KY LA MA MD ME
                           MI MN MO MS MT NC ND NE NH NJ NM NV NY
                           OH OK OR PA PR RI SC SD TN TX UT VA VI
                           VT WA WI WV WY)

  CREDIT_CARD_TYPES = %w(Visa MasterCard Amex Discover)

  MONTHS = %w(01 02 03 04 05 06 07 08 09 10 11 12)

  PAYMENT_TERMS = ['Due Upon Receipt', 'Net 30', 'Net 60', 'Net 90']

  SUBSCRIPTION_TERM_TYPES = %w(TERMED EVERGREEN)
end

require_relative 'zuora/version'
require_relative 'zuora/client'
require_relative 'zuora/models'
require_relative 'zuora/serializers'
require_relative 'zuora/resources'
require_relative 'zuora/util'