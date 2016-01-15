FactoryGirl.define do
  factory :subscription, class: Zuora::Models::Subscription do
    initialize_with { new(attributes) }

    renewal_term 3
    renewal_term_period_type 'week'
    term_type 'TERMED'
    auto_renew true
    invoice_target_date Date.new
    account_key 'A00001115'
    contract_effective_date Date.new
    invoice_collect false
    initial_term '12'
    initial_term_period_type 'Week'
    notes 'Test POST subscription from zuora-ruby'
  end
end
