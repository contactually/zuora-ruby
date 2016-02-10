require 'spec_helper'
describe 'create' do
  let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
  let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
  let(:vcr_options) do
    { match_requests_on: [:path] }
  end
  let(:client) { Zuora::Client.new(username, password, true) }

  let!(:auth_response) do
    VCR.use_cassette('authentication_success', match_requests_on: [:path]) do
      client
    end
  end

  [
    { type: :Account, factory: [:account] },
    { type: :BillRun, factory: [:bill_run] },
    { type: :Contact, factory: [:contact] },
    { type: :Refund, factory: [:refund] },
    { type: :Refund, factory: [:payment_method, :credit_card] }
  ].each do |object|
    type, factory = object.values_at :type, :factory

    describe "create #{type}" do
      vcr_options = { match_requests_on: [:path] }
      success_xpath =
        %w(/soapenv:Envelope/soapenv:Body/
           api:createResponse/api:result/api:Success).join

      context 'with good data' do
        let(:cassette) { "create_#{type.to_s.underscore}_success" }
        let(:response) do
          VCR.use_cassette(cassette, vcr_options) do
            client.call!(:create, type: type, objects: [build(*factory)])
          end
        end

        let(:status) do
          Nokogiri::XML(response.raw.body).xpath(
            success_xpath, Zuora::RESPONSE_NAMESPACES
          ).text
        end

        it 'request is successfully received' do
          expect(response.raw.status).to eq 200
        end

        it 'request is successfully executed' do
          expect(status).to eq 'true'
        end

        describe 'wrapped response' do
          it 'should work' do
            expect(
              response.to_h.envelope.body.create_response.result.success
            ).to eq('true')
          end
        end
      end

      context 'with missing data' do
        let(:cassette) { "create_#{type.to_s.underscore}_failure" }

        subject do
          VCR.use_cassette(cassette, vcr_options) do
            client.call!(:create, type: type, objects: [{}])
          end
        end

        let(:status) do
          Nokogiri::XML(response.raw.body).xpath(
            success_xpath, Zuora::RESPONSE_NAMESPACES
          ).text
        end

        it 'raises an exception' do
          expect { subject }.to raise_error(Zuora::Errors::InvalidValue)
        end

        it 'includes the full response on the error that gets raised' do
          begin
            subject
          rescue => e
            expect(e.response).to_not be_nil
          end
        end
      end
    end
  end
end
