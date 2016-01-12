# encoding: utf-8

module Zuora
  module Models
    class Subscription
      include ActiveModel::Model

      ATTRIBUTES = :account_key,
                   :invoice_owner_account_key,
                   :term_type,
                   :contract_effective_date,
                   :service_activation_date,
                   :customer_acceptance_date,
                   :term_start_date,
                   :initial_term,
                   :initial_term_period_type,
                   :auto_renew,
                   :renewal_term,
                   :renewal_term_period_type,
                   :renewal_setting,
                   :notes,
                   :invoice_collect,
                   :invoice,
                   :collect,
                   :invoice_separately,
                   :apply_credit_balance,
                   :invoice_target_date,
                   :subscribe_to_rate_plans

      attr_accessor(*ATTRIBUTES)

      def attributes
        ATTRIBUTES
      end

      validates :account_key,
                :term_type,
                :contract_effective_date,
                :subscribe_to_rate_plans,
                presence: true

      validates :term_type,
                inclusion: { in: Zuora::SUBSCRIPTION_TERM_TYPES }

      validates :initial_term,
                presence: true,
                if: proc { |sub| sub.term_type == 'EVERGREEN' }
    end
  end
end
