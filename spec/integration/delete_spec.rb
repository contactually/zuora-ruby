require 'spec_helper'

describe 'creates a subscription' do
  # https://knowledgecenter.zuora.com/BC_Developers/SOAP_API/E1_SOAP_API_Object_Reference/Contact

  let(:customer_email) { 'customer@email.com' }

  let(:success_xpath) do
    %w(/soapenv:Envelope
       soapenv:Body
       ns1:deleteResponse
       ns1:result
       ns1:success).join('/')
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
        name: :delete_one_subscription,
        type: :Subscription,
        ids: ['2c92c0f9528db6aa01528e3f2b704734']
      }
    ].each do |test|
      name, type, ids = test.values_at :name, :type, :ids
      describe "successfully executes #{name} .delete() request" do
        let(:response) do
          VCR.use_cassette(
            "delete_#{name}_success",
            match_requests_on: [:path]
          ) do
            client.call!(:delete, type: type, ids: ids)
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
