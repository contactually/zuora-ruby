# frozen_string_literal: true

FactoryBot.define do
  factory :payment_method, class: Hash do
    type 'CreditCard'

    trait :credit_card do
      use_default_retry_rule true

      credit_card_number '4242424242424242'
      credit_card_type 'Visa'
      credit_card_address_1 ''
      credit_card_address_2 ''
      credit_card_state 'MD'
      credit_card_city 'Silver Spring'
      credit_card_country 'USA'
      credit_card_postal_code 20_101
      credit_card_security_code 123

      credit_card_expiration_month 2
      credit_card_expiration_year 2017
      credit_card_holder_name 'Enoch Hall'
    end

    initialize_with { attributes }
  end
end
