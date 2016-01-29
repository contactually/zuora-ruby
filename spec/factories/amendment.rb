FactoryGirl.define do
  factory :amendment, class: Hash do
    contract_effective_date '2017-01-01'
    description 'Renewing at customer request'
    customer_acceptance_date '2017-01-01'
    effective_date '2017-01-01'
    service_activation_date '2017-01-01'
    subscription_id '2c92c0f95282215501528a9b494c0a48'
    status 'Completed'

    type 'NewProduct'
    name 'renewal'
    rate_plan_data do
      {
        rate_plan: {
          product_rate_plan_id: '2c92c0f950fa763f01510cbb937812dd'
        }
      }
    end

    initialize_with { attributes }
  end
end
