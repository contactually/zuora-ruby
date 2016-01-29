FactoryGirl.define do
  factory :account, class: Hash do
    auto_pay false
    batch 'Batch1'
    bill_cycle_day 1
    currency 'USD'
    name 'Some name'
    payment_term 'Due Upon Receipt'
    status 'Draft'
    account_name { "#{Faker::Name} Account" }

    initialize_with { attributes }
  end
end
