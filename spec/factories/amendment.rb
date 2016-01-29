FactoryGirl.define do
  factory :amendment, class: Hash do
    contract_effective_date '2017-01-01'
    description 'Renewing at customer request'
    customer_acceptance_date '2017-01-01'
    effective_date '2017-01-01'
    service_activation_date '2017-01-01'
    subscription_id '2c92c0f95282215501528a9b494c0a48'
    status 'Completed'

    trait :new_product do
      type 'NewProduct'
      name 'Product add'
      rate_plan_data do
        {
          rate_plan: {
            product_rate_plan_id: '2c92c0f950fa763f01510cbb937812dd'
          }
        }
      end
    end

    trait :remove_product do
      type 'RemoveProduct'
      name 'Product removal'
      rate_plan_data do
        {
          rate_plan: {
            amendment_subscription_rate_plan_id:
              '2c92c0f950fa763f01510cbb937812dd'
          }
        }
      end
    end

    trait :update_product do
      type 'UpdateProduct'
      name 'Product update'
      rate_plan_data do
        {
          rate_plan: {
            amendment_subscription_rate_plan_id:
              '2c92c0f950fa763f01510cbb937812dd'
          }
        }
      end
      rate_plan_charge_data do
        {
          rate_plan_charge: {
            product_rate_plan_id:
              '2c92c0f950fa763f01510cbb937812dd'
          }
        }
      end
    end

    initialize_with { attributes }
  end
end
