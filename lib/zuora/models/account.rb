module Zuora
  module Models
    class Account
      include DirtyValidAttr

      dirty_valid_attr :account_number,
                       type: String

      dirty_valid_attr :auto_pay,
                       type: Boolean,
                       required?: true

      dirty_valid_attr :bill_to_contact,
                       type: Zuora::Models::Contact,
                       required?: true

      dirty_valid_attr :bill_cycle_day,
                       type: String

      dirty_valid_attr :crm_id,
                       type: String

      dirty_valid_attr :currency,
                       type: String,
                       valid?: ->(c) { c.length == 3 }

      dirty_valid_attr :credit_card,
                       type: Zuora::Models::PaymentMethods::CreditCard,
                       required?: true

      dirty_valid_attr :name,
                       type: String

      dirty_valid_attr :hpm_credit_card_payment_method_id,
                       type: String

      dirty_valid_attr :notes,
                       type: String

      dirty_valid_attr :invoice_template_id,
                       type: String

      dirty_valid_attr :communication_profile_id,
                       type: String

      dirty_valid_attr :payment_gateway,
                       type: String

      dirty_valid_attr :payment_term,
                       type: String,
                       required?: true,
                       valid?: ->(s) { Zuora::PAYMENT_TERMS.include? s }

      dirty_valid_attr :sold_to_contact,
                       type: Zuora::Models::Contact,
                       required?: true

      dirty_valid_attr :subscription,
                       type: String

      alias_method :initialize, :initialize_attributes!
    end
  end
end
