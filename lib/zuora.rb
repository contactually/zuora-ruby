# encoding: utf-8

# Dependencies
require 'faraday'
require 'json'
require 'active_model'
require 'active_model_serializers'
require 'active_support'

module Zuora
  API_URL = 'https://webservices.iso-ne.com/api/v1.1'
  SANDBOX_URL = 'https://apisandbox-api.zuora.com/rest/v1'

  STATE_ABBREVIATIONS = %w(AA AE AP AK AL AR AZ CA CO CT DC DE FL
                           GA GU HI IA ID IL IN KS KY LA MA MD ME
                           MI MN MO MS MT NC ND NE NH NJ NM NV NY
                           OH OK OR PA PR RI SC SD TN TX UT VA VI
                           VT WA WI WV WY)

  CREDIT_CARD_TYPES = %w(Visa MasterCard Amex Discover)

  MONTHS = %w(01 02 03 04 05 06 07 08 09 10 11 12)

  def self.sample_account
    Zuora::Models::Account.new(
      :name => 'Abc',
      :bill_to_contact => Zuora::Models::Contact.new(
        :first_name => 'Abc',
        :last_name => 'Def'
      ),
      :sold_to_contact => Zuora::Models::Contact.new(
        :first_name => 'Abc',
        :last_name => 'Def'
      )
    )
  end
end

require_relative 'zuora/version'
require_relative 'zuora/client'
require_relative 'zuora/models'
require_relative 'zuora/util'