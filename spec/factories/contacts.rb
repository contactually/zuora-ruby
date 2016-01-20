FactoryGirl.define do
  factory :contact, class: Zuora::Models::Contact do
    first_name 'Abc'
    last_name 'Def'
    address_1 '123 Main St'
    city 'Palm Springs'
    state 'FL'
    zip_code '90210'
    country 'US'

    initialize_with { new(attributes) }

    factory :contact_hash, class: Hash do
      initialize_with { Hash[attributes] }
    end
  end
end
