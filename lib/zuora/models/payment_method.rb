module Zuora
  module Models
    class PaymentMethod
      include ActiveModel::Model
      include ActiveModel::Serialization

      ATTRIBUTES = :card_type,
                   :card_number,
                   :expiration_month,
                   :expiration_year,
                   :security_code


      attr_accessor *ATTRIBUTES

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

      def attributes
        Zuora::Util.attr_hash self, ATTRIBUTES
      end
    end
  end
end