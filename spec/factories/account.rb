# frozen_string_literal: true

FactoryBot.define do
  factory :account, class: Hash do
    auto_pay false
    batch 'Batch1'
    bill_cycle_day 1
    currency 'USD'
    name 'Some name'
    payment_term 'Due Upon Receipt'
    status 'Draft'
    account_name { "#{Faker::Name} Account" }
    stripe_customer_id__c 'cus_3bA2Ojilz1GYVU'

    initialize_with { attributes }
  end
end
