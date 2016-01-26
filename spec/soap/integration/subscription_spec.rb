require 'spec_helper'

describe 'creates a subscription' do
  # https://knowledgecenter.zuora.com/BC_Developers/SOAP_API/E1_SOAP_API_Object_Reference/Contact

  let(:account) do
    Zuora::Soap::Object[
      bill_cycle_day: 1,
      currency: 'USD',
      name: '',
      payment_term: '', # one of the payment terms defined in the UI
      status: nil, # set to 'Draft', 'Active', or 'Canceled' if using create()
    ]
  end

  let(:payment_method) do
    Zuora::Soap::Object[
      account_id: 1, # not required for .subscribe
      type: 'CreditCard',
      use_default_retry_rule: false,

      credit_card_number: '424242424242424242424',
      credit_card_type: 'Visa',
      credit_card_address_1: '',
      credit_card_address_2: '',
      credit_card_state: 'MD',
      credit_card_city: 'Silver Spring',
      credit_card_country: 'USA',
      credit_card_postal_code: 20_101,
      credit_card_security_code: 123,

      credit_card_expiration_month: 2,
      credit_card_expiration_year: 2017,
      credit_card_holder_name: 'Enoch Hall',
    ]
  end

  let(:contact) do
    Zuora::Soap::Object[
      first_name: 'John',
      last_name: 'Smith'
    ]
  end

  let(:subscribe_options) do
    Zuora::Soap::Object[
      generate_invoice: true,
      process_payments: true
    ]
  end

  let(:subscription) do
    Zuora::Soap::Object[
      auto_renew: true,
      contract_acceptance_date: '2016-07-03',
      contract_effective_date: '2016-07-03',
      initial_term: 12,
      name: 'A-S00000020090703080755',
      renewal_term: 12,
      service_activation_date: '2016-07-03',
      term_start_date: '2016-07-03',
    ]
  end

  let(:rate_plan) do
    Zuora::Soap::Object[
      product_rate_plan_id: '4028e6991f863ecb011fb8b7904141a6'
    ]
  end

  let(:subscription_data) do
    Zuora::Soap::Object[
      subscription: subscription,
      rate_plan_data: rate_plan
    ]
  end

  let(:subscribe_request) do
    Zuora::Soap::Object[
      account: account,
      payment_method: payment_method,
      bill_to_contact: contact,
      sold_to_contact: contact,
      subscribe_options: subscribe_options,
      subscription_data: subscription_data
    ]
  end

  let(:subscribe_call_envelope) do
    # TODO: Create
  end
end
