module Zuora
  module Models
    class PaymentMethod
      include ActiveModel::Model
      include ActiveModel::Serialization

      ATTRIBUTES = :account_key,
                   :credit_card_type,
                   :credit_card_number,
                   :expiration_month,
                   :expiration_year,
                   :security_code,
                   :default_payment_method,
                   :card_holder_info

      attr_accessor *ATTRIBUTES

      validates :account_key,
                :credit_card_type,
                :credit_card_number,
                :expiration_month,
                :expiration_year,
                :security_code,
                :presence => true

      validates :credit_card_type,
                :inclusion => { :in => Zuora::CREDIT_CARD_TYPES }

      validates :expiration_month,
                :inclusion => { :in => Zuora::MONTHS}

      validates :expiration_year,
                :length => { :is => 4 }
    end
  end
end