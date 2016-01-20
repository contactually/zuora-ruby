FactoryGirl.define do
  factory :subscription, class: Zuora::Models::Subscription do
    initialize_with { new(attributes) }

    renewal_term 3
    renewal_term_period_type 'Week'
    term_type 'TERMED'
    invoice_target_date Date.new
    account_key 'A00001115'
    contract_effective_date Date.new
    invoice true
    collect true
    initial_term 12
    initial_term_period_type 'Week'
    notes 'Test POST subscription from zuora-ruby'

    factory :subscription_model, class: Zuora::Models::Subscription do
      initialize_with { new(attributes) }
    end

    factory :subscription_hash, class: Hash do
      initialize_with { Hash[attributes] }
    end
  end
end
