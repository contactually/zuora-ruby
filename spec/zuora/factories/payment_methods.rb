FactoryGirl.define do
  factory :credit_card, class: Zuora::Models::PaymentMethods::CreditCard do
    initialize_with { new(attributes) }

    card_type 'Visa'
    card_number '4111111111111111'
    expiration_month '03'
    expiration_year '2017'
    security_code '122'
  end
end
