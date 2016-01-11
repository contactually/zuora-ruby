# encoding: utf-8

module Zuora
  module Models
    class Account
      include ActiveModel::Model
      # See http://api.rubyonrails.org/classes/ActiveModel/Dirty.html

      ATTRIBUTES = :account_number,
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
                   :subscription

      attr_accessor *ATTRIBUTES

      def attributes
        ATTRIBUTES
      end

      Zuora::Models::Utils.validate_children self,
                                             'contact',
                                             :bill_to_contact,
                                             :sold_to_contact

      validates :auto_pay,
                :bill_to_contact,
                :credit_card,
                :currency,
                :name,
                :payment_term,
                :sold_to_contact,
                :presence => true

      validates :currency,
                :length => { :is => 3 }

      validates :payment_term,
                :inclusion => { :in => Zuora::PAYMENT_TERMS }

    end
  end
end