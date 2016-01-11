FactoryGirl.define do
  factory :rate_plan_charge_tier, :class => Zuora::Models::RatePlanChargeTier do
    tier 1
    starting_unit 1
    ending_unit 10
    price 60
    price_format 'FlatFee'
  end
end
