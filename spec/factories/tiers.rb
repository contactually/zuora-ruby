FactoryGirl.define do
  factory :tier, class: Zuora::Models::Tier do
    tier 1
    starting_unit 1
    ending_unit 10
    price 60
    price_format 'FlatFee'

    initialize_with { new(attributes) }

    factory :tier_hash, class: Hash do
      initialize_with { Hash[attributes] }
    end
  end
end
