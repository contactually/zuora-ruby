FactoryGirl.define do
  factory :rate_plan_charge, class: Zuora::Models::RatePlanCharge do
    initialize_with { new(attributes) }

    product_rate_plan_charge_id 'ff8080811ca15d19011cdda9b0ad3b51'
  end
end
