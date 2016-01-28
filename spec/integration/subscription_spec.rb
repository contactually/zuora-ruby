require 'spec_helper'

describe 'creates a subscription' do
  # https://knowledgecenter.zuora.com/BC_Developers/SOAP_API/E1_SOAP_API_Object_Reference/Contact

  let(:customer_email) { 'customer@email.com' }

  let(:soap_success_xpath) do
    %w(/soapenv:Envelope
       soapenv:Body
       api:subscribeResponse
       api:result
       api:Success).join('/')
  end

  let(:account) do
    Zuora::Object[
      auto_pay: false,
      batch: 'Batch1',
      bill_cycle_day: 1,
      currency: 'USD',
      name: 'Some name',
      payment_term: 'Due Upon Receipt',
      status: 'Draft',
      account_name: customer_email
    ]
  end

  let(:payment_method) do
    Zuora::Object[
      type: 'CreditCard',
      use_default_retry_rule: false,

      credit_card_number: '4242424242424242',
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
    Zuora::Object[
      first_name: 'John',
      last_name: 'Smith',
      work_email: customer_email
    ]
  end

  let(:subscribe_options) do
    Zuora::Object[
      generate_invoice: false,
      process_payments: false
    ]
  end

  let(:subscription) do
    Zuora::Object[
      auto_renew: true,
      contract_acceptance_date: '2016-07-03',
      contract_effective_date: '2016-07-03',
      initial_term: 12,
      name: 'A-S00000020090703080859',
      renewal_term: 12,
      service_activation_date: '2016-07-03',
      term_start_date: '2016-07-03',
      term_type: 'EVERGREEN'
    ]
  end

  let(:rate_plan) do
    Zuora::Object[
      product_rate_plan_id: '2c92c0f950fa763f01510cbb937812dd'
    ]
  end

  let(:subscribe_data) do
    {
      account: account,
      payment_method: payment_method,
      bill_to_contact: contact,
      sold_to_contact: contact,
      subscription: subscription,
      rate_plan: rate_plan
    }
  end

  context 'with valid data' do
    ## Integration
    let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
    let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
    let(:vcr_options) { { match_requests_on: [:path] } }
    let(:client) { Zuora::Client.new(username, password, true) }

    ## Authentication
    let!(:auth_response) do
      VCR.use_cassette('soap_authentication', match_requests_on: [:path]) do
        client.authenticate!
      end
    end

    let(:subscribe_response) { client.call!(:subscribe, subscribe_data) }
    let(:subscribe_body_xml) { Nokogiri::XML(subscribe_response.body) }

    it 'successfully executes subscribe request' do
      VCR.use_cassette('subscribe_success', match_requests_on: [:path]) do
        expect(subscribe_response.status).to eq 200

        expect(
          subscribe_body_xml.xpath(
            soap_success_xpath,
            Zuora::NAMESPACES
          ).text
        ).to eq 'true'
      end
    end
  end
end
