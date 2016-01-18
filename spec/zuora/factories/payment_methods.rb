FactoryGirl.define do
  factory :credit_card do
    card_type 'Visa'
    card_number '4111111111111111'
    expiration_month '03'
    expiration_year 2017
    security_code '122'

    factory :credit_card_model, class: Zuora::Models::CreditCard do
      initialize_with { new(attributes) }
    end

    factory :credit_card_hash, class: Hash do
      initialize_with { Hash[attributes] }
    end
  end
end
