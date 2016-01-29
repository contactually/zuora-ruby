FactoryGirl.define do
  factory :subscription, class: Hash do
    auto_renew true
    contract_acceptance_date '2016-07-03'
    contract_effective_date '2016-07-03'
    initial_term 12
    name 'A-S00000020090703080864'
    renewal_term 12
    service_activation_date '2016-07-03'
    term_start_date '2016-07-03'
    term_type 'EVERGREEN'

    initialize_with { attributes }
  end
end
