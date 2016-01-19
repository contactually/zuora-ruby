require 'utils/schema_model'

module Zuora::Models; end

require_relative 'models/tier'
require_relative 'models/charge'
require_relative 'models/charge_update'
require_relative 'models/plan'
require_relative 'models/subscription'

# Subscription resource nested data structure
#
#  subscription                [Zuora::Models::Subscription]
#    :subscribe_to_rate_plans  [Zuora::Models::Plan]
#       :charge_overrides      [Zuora::Models::Charge]
#          :tiers              [Zuora::Models::Tier]

require_relative 'models/card_holder_info'
require_relative 'models/contact'
require_relative 'models/credit_card'
require_relative 'models/subscription'
require_relative 'models/subscription_update'
require_relative 'models/account'

# Account resource nested data structure
#
#  :account          [Zuora::Models::Account]
#    :subscription     [Zuora::Models::Subscription]
#      (see subscription structure above)
#    :bill_to_contact  [Zuora::Models::Contact]
#    :sold_to_contact  [Zuora::Models::Contact]
#    :credit_card      [Zuora::Models::CreditCard]
#    :tiers            [Zuora::Models::Tier]
