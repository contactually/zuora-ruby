FactoryGirl.define do
  factory :credit_card, class: Zuora::Models::CreditCard do
    card_type 'Visa'
    card_number '4242424242424242'
    expiration_month '03'
    expiration_year 2017
    security_code '122'

    initialize_with { new(attributes) }

    factory :credit_card_hash, class: Hash do
      initialize_with { Hash[attributes] }
    end
  end
end
