# frozen_string_literal: true

require 'spec_helper'

describe 'creates a subscription' do
  # https://knowledgecenter.zuora.com/BC_Developers/SOAP_API/E1_SOAP_API_Object_Reference/Contact

  let(:customer_email) { 'customer@email.com' }

  let(:soap_success_xpath) do
    %w[/soapenv:Envelope
       soapenv:Body
       api:subscribeResponse
       api:result
       api:Success].join('/')
  end

  let(:subscribe_data) do
    {
      account: build(:account),
      payment_method: build(:payment_method, :credit_card),
      bill_to_contact: build(:contact),
      sold_to_contact: build(:contact),
      subscription: build(:subscription),
      rate_plan: build(:rate_plan)
    }
  end

  context 'with valid data' do
    let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
    let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
    let(:vcr_options) { { match_requests_on: [:path] } }
    let(:client) { Zuora::Soap::Client.new(username, password, true) }

    ## Authentication
    let!(:auth_response) do
      VCR.use_cassette('soap/authentication_success') do
        client
      end
    end

    let(:subscribe_response) { client.call!(:subscribe, subscribe_data) }
    let(:subscribe_body_xml) { Nokogiri::XML(subscribe_response.raw.body) }

    it 'successfully executes subscribe request' do
      VCR.use_cassette('soap/subscribe_success') do
        expect(subscribe_response.raw.status).to eq 200

        expect(
          subscribe_body_xml.xpath(
            soap_success_xpath,
            Zuora::RESPONSE_NAMESPACES
          ).text
        ).to eq 'true'
      end
    end
  end
end
