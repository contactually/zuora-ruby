FactoryGirl.define do
  factory :plan do
    initialize_with { new(attributes) }

    product_rate_plan_id 'ff8080811ca15d19011cdda9b0ad3b51'

    factory :plan_model, class: Zuora::Models::Plan do
      initialize_with { new(attributes) }
    end

    factory :plan_hash, class: Hash do
      initialize_with { Hash[attributes] }
    end
  end
end
