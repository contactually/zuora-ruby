FactoryGirl.define do
  factory :rate_plan, class: Zuora::Models::RatePlan do
    initialize_with { new(attributes) }

    product_rate_plan_id 'ff8080811ca15d19011cdda9b0ad3b51'
  end
end
