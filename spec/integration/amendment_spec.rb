require 'spec_helper'

describe 'makes amends' do
  let(:xpath) do
    '/soapenv:Envelope/soapenv:Body/ns1:amendResponse/ns1:results/ns1:Success'
  end

  let(:xpath_text) do
    lambda do |response, xpath|
      Nokogiri::XML(response.body)
        .xpath(xpath, Zuora::RESPONSE_NAMESPACES)
        .text
    end
  end

  let(:add_product_amendment) do
    {
      contract_effective_date: '2017-01-01',
      description: 'Renewing at customer request',
      customer_acceptance_date: '2017-01-01',
      effective_date: '2017-01-01',
      service_activation_date: '2017-01-01',
      subscription_id: '2c92c0f95282215501528a9b494c0a48',
      status: 'Completed',

      # New Product Amendment
      type: 'NewProduct',
      name: 'renewal',
      rate_plan_data: {
        rate_plan: {
          product_rate_plan_id: '2c92c0f950fa763f01510cbb937812dd'
        }
      }
    }
  end

  let(:amend_options) do
    {
      generate_invoice: true,
      process_payments: true
    }
  end

  let(:preview_options) do
    {
      enable_preview_mode: false,
      preview_through_term_end: false
    }
  end

  let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
  let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
  let(:client) { Zuora::Client.new(username, password, true) }

  let(:vcr_options) do
    { match_requests_on: [:path] }
  end

  before do
    VCR.use_cassette('soap_authentication', vcr_options) do
      client.authenticate!
    end
  end

  let(:add_product_amend_response) do
    VCR.use_cassette('soap_amend_add_product_success', vcr_options) do
      client.call!(
        :amend,
        amendments: add_product_amendment,
        amend_options: amend_options,
        preview_options: preview_options
      )
    end
  end

  it 'has successful response' do
    expect(add_product_amend_response.status).to eq 200
    expect(xpath_text.call(add_product_amend_response, xpath)).to eq 'true'
  end
end
