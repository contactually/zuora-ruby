FactoryGirl.define do
  factory :contact, class: Zuora::Models::Contact do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    address_1 Faker::Address.street_address
    city Faker::Address.city
    state Faker::Address.state_abbr
    zip_code Faker::Address.zip
    country 'USA'

    initialize_with { new(attributes) }

    factory :contact_hash, class: Hash do
      initialize_with { Hash[attributes] }
    end
  end
end
