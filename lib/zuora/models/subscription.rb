# encoding: utf-8

module Zuora
  module Models
    class Subscription
      include DirtyValidAttr

      dirty_valid_attr :auto_renew, type: Boolean
      dirty_valid_attr :apply_credit_balance, type: String
      dirty_valid_attr :account_key, type: String, required?: true
      dirty_valid_attr :contract_effective_date, type: Date, required?: true
      dirty_valid_attr :collect, type: String
      dirty_valid_attr :customer_acceptance_date, type: Date
      dirty_valid_attr :initial_term, type: String, required?: ->(model) { model.term_type == 'EVERGREEN' }
      dirty_valid_attr :initial_term_period_type, type: String
      dirty_valid_attr :invoice_owner_account_key, type: String
      dirty_valid_attr :invoice_collect, type: String
      dirty_valid_attr :invoice, type: String
      dirty_valid_attr :invoice_separately, type: String
      dirty_valid_attr :invoice_target_date, type: Date
      dirty_valid_attr :notes, type: String
      dirty_valid_attr :renewal_term, type: String
      dirty_valid_attr :renewal_term_period_type, type: String
      dirty_valid_attr :renewal_setting, type: String
      dirty_valid_attr :service_activation_date, type: Date
      dirty_valid_attr :subscribe_to_rate_plans,
                       type: Array,
                       required?: false
      dirty_valid_attr :term_start_date, type: Date
      dirty_valid_attr :term_type, type: String,
                       required?: true,
                       valid?: ->(t) { Zuora::SUBSCRIPTION_TERM_TYPES.include? t }

      def initialize(attrs = {})
        set_attributes!(attrs)
      end
    end
  end
end
