FactoryGirl.define do
  factory :account, class: Zuora::Models::Account do
    name SecureRandom.uuid
    auto_pay true
    currency 'USD'
    bill_cycle_day '0'
    payment_term 'Net 30'

    initialize_with { new(attributes) }

    factory :account_hash, class: Hash do
      initialize_with { Hash[attributes] }
    end
  end
end
