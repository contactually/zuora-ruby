module Zuora
  class PaymentMethod
    include ActiveModel::Model

    attr_accessor :account_key,
                  :credit_card_type,
                  :credit_card_number,
                  :expiration_month,
                  :expiration_year,
                  :security_code,
                  :default_payment_method,
                  :card_holder_info

    validates :account_key,
              :credit_card_type,
              :credit_card_number,
              :expiration_month,
              :expiration_year,
              :security_code,
              :presence => true


    validates :credit_card_type,
              :inclusion => { :in => %w(Visa MasterCard Amex Discover) }

    validates :expiration_month,
              :inclusion => { :in => %w(01 02 03 04 05 06 07 08 09 10 11 12)}

    validates :expiration_year,
              :length => { :is => 4 }
  end
end