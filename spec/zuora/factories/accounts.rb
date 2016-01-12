FactoryGirl.define do
  factory :account, class: Zuora::Models::Account do
    name 'Abc'
    auto_pay true
    currency 'USD'
    bill_cycle_day '0'
    payment_term 'Net 30'
  end
end
