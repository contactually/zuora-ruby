# encoding: utf-8

module Zuora
  class Account
    include ActiveModel::Model

    attr_accessor :account_number,
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

    validates :bill_to_contact,
              :currency,
              :sold_to_contact,
              :name,
              :presence => true

    validates :currency,
              :length => { :is => 3 }

    validates_each :bill_to_contact, :sold_to_contact do |record, attr, value|
      unless value && value.respond_to?(:valid?) && value.valid?
        record.errors.add attr, 'invalid contact'
      end
    end

    private

  end
end