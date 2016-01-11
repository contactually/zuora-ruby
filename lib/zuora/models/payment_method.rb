module Zuora
  module Models
    class PaymentMethod
      include ActiveModel::Model

      ATTRIBUTES = :card_type,
                   :card_number,
                   :expiration_month,
                   :expiration_year,
                   :security_code

      attr_accessor *ATTRIBUTES

      def attributes
        ATTRIBUTES
      end

      validates :card_type,
                :card_number,
                :expiration_month,
                :expiration_year,
                :security_code,
                :presence => true

      validates :card_type,
                :inclusion => { :in => Zuora::CREDIT_CARD_TYPES }

      validates :expiration_month,
                :inclusion => { :in => Zuora::MONTHS}

      validates :expiration_year,
                :length => { :is => 4 }

    end
  end
end