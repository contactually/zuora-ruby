FactoryGirl.define do
  factory :tier do
    tier 1
    starting_unit 1
    ending_unit 10
    price 60
    price_format 'FlatFee'

    factory :tier_model, class: Zuora::Models::Tier do
      initialize_with { new(attributes) }
    end

    factory :tier_hash, class: Hash do
      initialize_with { Hash[attributes] }
    end
  end
end
