require 'spec_helper'

describe 'creates a subscription' do
  # https://knowledgecenter.zuora.com/BC_Developers/SOAP_API/E1_SOAP_API_Object_Reference/Contact

  let(:customer_email) { 'customer@email.com' }

  let(:account) do
    Zuora::Soap::Object[
      auto_pay: false,
      batch: 'Batch1',
      bill_cycle_day: 1,
      currency: 'USD',
      name: '',
      payment_term: 'Due Upon Receipt',
      status: 'Draft',
      account_name: customer_email
    ]
  end

  let(:payment_method) do
    Zuora::Soap::Object[
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
      last_name: 'Smith',
      work_email: customer_email
    ]
  end

  let(:subscribe_options) do
    Zuora::Soap::Object[
      generate_invoice: false,
      process_payments: false
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
      term_type: 'EVERGREEN'
    ]
  end

  let(:rate_plan) do
    Zuora::Soap::Object[
      product_rate_plan_id: '4028e6991f863ecb011fb8b7904141a6'
    ]
  end

  let(:subscribe_call) do
    Zuora::Soap::Calls::Subscribe.new(
      account: account,
      payment_method: payment_method,
      bill_to_contact: contact,
      sold_to_contact: contact,
      subscription: subscription,
      rate_plan: rate_plan,
      token: 123
    )
  end

  let(:subscribe_call_xml_builder) do
    subscribe_call.xml_builder
  end

  let(:subscribe_call_xml) do
    subscribe_call_xml_builder.to_xml
  end

  let(:subscribe_call_xml_parsed) do
    Nokogiri::XML(subscribe_call_xml)
  end

  let(:subscribes_selector) do
    %w(//soapenv:Envelope
       soapenv:Body
       ns1:subscribe
       ns1:subscribes
    )
  end

  let(:has_element) do
    # @param [Nokogiri::XML::Document] xml
    # @param [String] element_name
    lambda do |xml_doc, element_name|
      selector = subscribes_selector.push(element_name).join('/')
      xml_doc.xpath(selector).present?
    end
  end

  context 'with valid data' do
    it 'successfully constructs .subscribe() call' do
      expect { subscribe_call }.to_not raise_exception
    end

    it 'returns object that is serializable as XML' do
      expect(subscribe_call_xml_builder).to respond_to(:to_xml)
    end

    %w(Account
       PaymentMethod
       BillToContact
       SubscriptionData).each do |object_name|
      it "contains object #{object_name}" do
        expect(
          has_element.call(
            subscribe_call_xml_parsed, "ns1:#{object_name}"
          )
        ).to be_truthy
      end
    end

    ## Integration
    let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
    let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
    let(:vcr_options) { { match_requests_on: [:path] } }
    let(:client) { Zuora::Soap::Client.new(username, password, true) }

    ## Authentication
    let!(:auth_response) do
      VCR.use_cassette('soap_authentication', match_requests_on: [:path]) do
        client.authenticate!
      end
    end

    it 'succcessfully executes request' do
      VCR.use_cassette('subscribe_success', match_requests_on: [:path]) do
        expect(client.request(subscribe_call_xml_builder).status).to eq 200
      end
    end
  end
end
