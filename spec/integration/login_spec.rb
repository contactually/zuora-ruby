require 'spec_helper'
require 'nokogiri'

describe Zuora::Client do
  let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
  let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
  let(:vcr_options) do
    { match_requests_on: [:path] }
  end
  let!(:client) { Zuora::Client.new(username, password, true) }

  let!(:auth_response) do
    VCR.use_cassette('authentication', match_requests_on: [:path]) do
      client.authenticate!
    end
  end

  let(:soap_success_xpath) do
    '/soapenv:Envelope/soapenv:Body/api:createResponse/api:result/api:Success'
  end

  it 'receives successful auth response' do
    expect(auth_response.status).to eq 200
  end

  it 'sets client auth token' do
    expect(client.session_token).to_not be_nil
  end
end
