module Zuora
  module Models
    class Subscription
      include ActiveModel::Model

      ATTRIBUTES = :account_key,
        :invoice_owner_account_Key,
        :term_type,
        :contact_effective_date,
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
        :subscribe_to_rate_plans,

      attr_accessor *ATTRIBUTES

      def attributes
        ATTRIBUTES
      end
    end
  end
end
