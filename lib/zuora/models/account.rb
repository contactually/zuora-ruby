# encoding: utf-8

module Zuora
  module Models
    class Account
      include ActiveModel::Model

      ATTRIBUTES = [:account_number,
                    :auto_pay,
                    :bill_to_contact,
                    :bill_cycle_day,
                    :crm_id,
                    :currency,
                    :credit_card,
                    :name,
                    :hpm_credit_card_payment_method_id,
                    :notes,
                    :invoice_template_id,
                    :communication_profile_id,
                    :payment_gateway,
                    :payment_term,
                    :sold_to_contact,
                    :subscription]

      attr_accessor *ATTRIBUTES

      validates :bill_to_contact,
                :currency,
                :sold_to_contact,
                :name,
                :presence => true

      validates :currency,
                :length => { :is => 3 }

      # Todo: Factor out and supply this via a mixin to form a nice dsl
      # e.g. validates :bill_to_contact, :as => :contact
      validates_each :bill_to_contact, :sold_to_contact do |record, attr, value|
        if !value.respond_to?(:valid?) || !value.respond_to?(:errors)
          record.errors.add attr, 'invalid contact'
        elsif value.invalid?
          record.errors.add attr, value.errors.join(',')
        end
      end

      private
    end
  end
end