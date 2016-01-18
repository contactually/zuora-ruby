FactoryGirl.define do
  factory :card_holder do
    card_holder_name 'First Last'
    address_line_1 '123 Main St'
    city 'Dayton'
    state 'OH'
    country 'USA'
    phone '301-555-1212'
    email 'abc@abc.com'
    zip_code '12345'

    factory :card_holder_model, class: Zuora::Models::CardHolderInfo do
      initialize_with { new(attributes) }
    end

    factory :card_holder_hash, class: Hash do
      initialize_with { Hash[attributes] }
    end
  end
end
