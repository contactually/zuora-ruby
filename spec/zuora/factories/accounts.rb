FactoryGirl.define do
  factory :account do
    name 'Abc'
    auto_pay true
    currency 'USD'
    billing_cycle_day '0'
    payment_term 'Net 30'
    account_number '123456'

    factory :account_model, class: Zuora::Models::Account do
      initialize_with { new(attributes) }
    end

    factory :account_hash, class: Hash do
      initialize_with { Hash[attributes] }
    end
  end
end
