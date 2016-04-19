require 'spec_helper'

# https://knowledgecenter.zuora.com/DC_Developers/SOAP_API/E_SOAP_API_Calls/queryMore_call
describe 'executes a query_more request' do
  let(:query) { 'SELECT Id FROM Account' }
  let(:expected_size) { 2552 }
  let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
  let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
  let(:vcr_options) { { match_requests_on: [:path] } }
  let(:client) { Zuora::Soap::Client.new(username, password, true) }
  let!(:auth_response) do
    VCR.use_cassette('soap/authentication_success') do
      client
    end
  end

  subject do
    VCR.use_cassette('soap/query_more_success', match_requests_on: [:path]) do
      # Get the first batch
      response = client.call!(:query, query)
      result = response.to_h.envelope.body.query_response.result
      ids = result.records.map(&:id)
      query_locator = result.query_locator

      # Get more batches until there's no more query_locator
      while query_locator.is_a?(String)
        response = client.call!(:query_more, query_locator)
        result = response.to_h.envelope.body.query_more_response.result
        ids += result.records.map(&:id)
        query_locator = result.query_locator
      end

      ids
    end
  end

  it 'should be the expected size' do
    expect(subject.size).to eq expected_size
  end
end
