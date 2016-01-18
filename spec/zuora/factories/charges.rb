FactoryGirl.define do
  factory :charge do
    product_rate_plan_charge_id 'ff8080811ca15d19011cdda9b0ad3b51'
    quantity 1

    factory :charge_model, class: Zuora::Models::Charge do
      initialize_with { new(attributes) }
    end

    factory :charge_hash, class: Hash do
      initialize_with { Hash[attributes] }
    end
  end
end
