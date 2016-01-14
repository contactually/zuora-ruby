module Zuora
  module Models
    module PaymentMethods
      class CreditCard
        include DirtyValidAttr

        dirty_valid_attr :card_type,
                         required?: true,
                         valid?: ->(c) { Zuora::CREDIT_CARD_TYPES.include? c }

        dirty_valid_attr :card_number,
                         required?: true

        dirty_valid_attr :expiration_month,
                         required?: true,
                         valid?: ->(m) { Zuora::MONTHS.include? m }

        dirty_valid_attr :expiration_year,
                         required?: true,
                         valid?: ->(y) { (y.length == 4) and (y > DateTime.now.year - 1) }

        dirty_valid_attr :security_code,
                         required: true

        def initialize(attrs)
          set_attributes! attrs
        end
      end
    end
  end
end
