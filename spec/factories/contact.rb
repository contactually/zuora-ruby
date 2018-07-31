# frozen_string_literal: true

FactoryGirl.define do
  factory :contact, class: Hash do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    work_email { Faker::Internet.email }
    account_id '2c92c0f85282111401528b73648b76fc'

    initialize_with { attributes }
  end
end
