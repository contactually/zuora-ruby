module Zuora
  module Models
    module PaymentMethods
      class CreditCard
        include DirtyValidAttr

        dirty_valid_attr :card_type,
                         type: String,
                         required?: true,
                         valid?: one_of(Zuora::CREDIT_CARD_TYPES)

        dirty_valid_attr :card_number,
                         type: String,
                         required?: true

        dirty_valid_attr :expiration_month,
                         type: String,
                         required?: true,
                         valid?: one_of(Zuora::MONTHS)

        dirty_valid_attr :expiration_year,
                         type: String,
                         required?: true,
                         valid?: valid_year

        dirty_valid_attr :security_code,
                         type: String,
                         required: true

        def initialize(attrs)
          initialize_attributes! attrs
        end
      end
    end
  end
end
