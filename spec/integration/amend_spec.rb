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

  let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
  let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
  let(:client) { Zuora::Client.new(username, password, true) }

  let(:vcr_options) do
    { match_requests_on: [:path] }
  end

  before do
    VCR.use_cassette('authentication', vcr_options) do
      client.authenticate!
    end
  end

  let(:add_product_amend_response) do
    VCR.use_cassette('amend_add_product_success', vcr_options) do
      client.call!(
        :amend,
        amendments: build(:amendment),
        amend_options: build(:amend_options),
        preview_options: build(:preview_options)
      )
    end
  end

  it 'has successful response' do
    expect(add_product_amend_response.status).to eq 200
    expect(xpath_text.call(add_product_amend_response, xpath)).to eq 'true'
  end
end
