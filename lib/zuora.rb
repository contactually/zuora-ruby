# encoding: utf-8

# Dependencies
require 'faraday'
require 'json'
require 'active_support'
require 'active_support/core_ext/string'

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

  # SUBSCRIPTION

  SUBSCRIPTION_TERM_TYPES = %w(TERMED EVERGREEN)

  DISCOUNT_TYPES = %w(ONETIME
                      RECURRING
                      USAGE
                      ONETIMERECURRING
                      ONETIMEUSAGE
                      RECURRINGUSAGE
                      ONETIMERECURRINGUSAG) # typo in zuora docs?

  DISCOUNT_LEVELS = %w(rateplan subscription account)

  LIST_PRICE_BASES = %w(Per_Billing_Period
                        Per_Month
                        Per_Week)

  TRIGGER_EVENTS = %w(UCE USA UCA USD)

  END_DATE_CONDITIONS = %w(Subscription_End
                           Fixed_Period
                           Specific_End_Date)

  UP_TO_PERIODS = %w(Days Weeks Months Years)

  BILLING_PERIODS = %w(Month
                       Quarter
                       Semi_Annual
                       Annual
                       Eighteen_Months
                       Two_Years
                       Three_Years
                       Five_Years
                       Specific_Months
                       Subscription_Term
                       Week
                       Specific_Weeks)

  BILLING_TIMINGS = %w(IN_ADVANCE IN_ARREARS)

  BILL_CYCLE_TYPES = %w(DefaultFromCustomer
                        SpecificDayofMonth
                        SubscriptionStartDay
                        ChargeTriggerDay
                        SpecificDayOfWeek)

  PRICE_CHANGE_OPTIONS = %w(NoChange
                            SpecificPercentageValue
                            UseLatestProductCatalogPricing)

  WEEKDAYS = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
end

require_relative 'utils/composite_types'
require_relative 'utils/schema_model'

require_relative 'zuora/version'
require_relative 'zuora/client'
require_relative 'zuora/soap_client'
require_relative 'zuora/models'

# require_relative 'zuora/subscriptions/create'
# require_relative 'zuora/subscriptions/update'
