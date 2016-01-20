FactoryGirl.define do
  factory :plan, class: Zuora::Models::Plan do
    product_rate_plan_id 'ff8080811ca15d19011cdda9b0ad3b51'

    initialize_with { new(attributes) }

    factory :plan_hash, class: Hash do
      initialize_with { Hash[attributes] }
    end
  end
end
