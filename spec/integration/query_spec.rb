require 'spec_helper'

describe 'creates a subscription' do
  # https://knowledgecenter.zuora.com/BC_Developers/SOAP_API/E1_SOAP_API_Object_Reference/Contact

  let(:customer_email) { 'customer@email.com' }

  let(:success_xpath) do
    %w(/soapenv:Envelope
       soapenv:Body
       ns1:queryResponse
       ns1:result
       ns1:done).join('/')
  end

  let(:query) { 'SELECT Id FROM BillRun' }

  context 'with valid data' do
    let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
    let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
    let(:vcr_options) { { match_requests_on: [:path] } }
    let(:client) { Zuora::Client.new(username, password, true) }

    let!(:auth_response) do
      VCR.use_cassette('authentication_success', match_requests_on: [:path]) do
        client.authenticate!
      end
    end

    [
      {
        name: :simple_get,
        query: 'SELECT Id FROM BillRun'
      },
      {
        name: :less_than_sign,
        query: %(
          SELECT Id
          FROM Subscription
          WHERE subscriptionStartDate < '#{Date.today}'
        )
      },
      {
        name: :greater_than_sign,
        query: %(
          SELECT Id
          FROM Subscription
          WHERE subscriptionStartDate > '#{(Date.today - 10)}'
        )
      }
    ].each do |test|
      name, query = test.values_at :name, :query
      describe "successfully executes #{name}.query() request" do
        let(:response) do
          VCR.use_cassette(
            "query_#{name}_success",
            match_requests_on: [:path]
          ) do
            client.call!(:query, query)
          end
        end
        let(:response_body) { Nokogiri::XML(response.raw.body) }
        let(:success) do
          response_body.xpath(success_xpath, Zuora::RESPONSE_NAMESPACES)
        end

        it 'request is succesfully received' do
          expect(response.raw.status).to eq 200
        end

        it 'is successfully executed' do
          expect(success.text).to eq 'true'
        end
      end
    end
  end
end
