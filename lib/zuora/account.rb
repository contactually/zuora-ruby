# encoding: utf-8

module Zuora
  class Account
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON

    define_attribute_methods :name

    attr_accessor :account_number,
                  :auto_pay,
                  :bill_to_contact,
                  :bill_cycle_day,
                  :currency,
                  :credit_card,
                  :name,
                  :crm_id,
                  :notes,
                  :invoice_template_id,
                  :communication_profile_id,
                  :payment_gateway,
                  :payment_term,
                  :sold_to_contact,
                  :hpm_credit_card_payment_method_id,
                  :subscription

    validates_presence_of :bill_to_contact,
                          :currency,
                          :sold_to_contact,
                          :name


    def attributes
      { 'name' => name,
        'batch' => batch }
      # remove keys with nil values
    end

  end
end