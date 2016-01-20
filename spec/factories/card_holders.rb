FactoryGirl.define do
  factory :card_holder do
    address_line_1 Faker::Address.street_address
    city Faker::Address.city
    state Faker::Address.state_abbr
    zip_code Faker::Address.zip
    country 'USA'
    phone Faker::PhoneNumber.cell_phone
    email Faker::Internet.email

    factory :card_holder_model, class: Zuora::Models::CardHolderInfo do
      initialize_with { new(attributes) }
    end

    factory :card_holder_hash, class: Hash do
      initialize_with { Hash[attributes] }
    end
  end
end
