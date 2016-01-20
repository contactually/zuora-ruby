FactoryGirl.define do
  factory :subscription, class: Zuora::Models::Subscription do
    initialize_with { new(attributes) }

    factory :subscription_hash, class: Hash do
      initialize_with { Hash[attributes] }
    end
  end
end
