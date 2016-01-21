require 'spec_helper'
require 'nokogiri'

describe Zuora::SoapClient do
  let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
  let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
  let(:client) { Zuora::SoapClient.new(username, password, true) }
  let!(:auth_response) do
    VCR.use_cassette('soap_authentication', match_requests_on: [:path]) do
      client.authenticate!
    end
  end
  let!(:create_bill_run_response) do
    VCR.use_cassette('soap_create_bill_run', match_requests_on: [:path]) do
      client.create_bill_run!(
        target_date: '2016-03-01',
        invoice_date: '2016-03-01'
      )
    end
  end

  it 'receives successful auth response' do
    expect(auth_response.status).to eq 200
  end

  it 'sets client auth token' do
    expect(client.session_token).to_not be_nil
  end

  it 'successfully creates a bill run' do
    expect(create_bill_run_response.status).to eq 200
  end
end
