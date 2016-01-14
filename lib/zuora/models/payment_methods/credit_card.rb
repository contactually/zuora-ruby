module Zuora
  module Models
    module PaymentMethods
      class CreditCard
        include DirtyValidAttr

        dirty_valid_attr :card_type,
                         type: String,
                         required?: true,
                         valid?: ->(c) { Zuora::CREDIT_CARD_TYPES.include? c }

        dirty_valid_attr :card_number,
                         type: String,
                         required?: true

        dirty_valid_attr :expiration_month,
                         type: String,
                         required?: true,
                         valid?: ->(m) { Zuora::MONTHS.include? m }

        dirty_valid_attr :expiration_year,
                         type: String,
                         required?: true,
                         valid?: ->(y) { (y.to_s.length == 4) and (y.to_i > DateTime.now.year - 1) }

        dirty_valid_attr :security_code,
                         type: String,
                         required: true

        def initialize(attrs)
          set_attributes! attrs
        end
      end
    end
  end
end
