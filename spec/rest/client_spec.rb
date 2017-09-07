require 'spec_helper'

if ENV['ZUORA_SANDBOX_USERNAME'].nil? || ENV['ZUORA_SANDBOX_PASSWORD'].nil?
  fail 'Please set ZUORA_SANDBOX_USERNAME and ZUORA_SANDBOX_PASSWORD in .env'
end

describe Zuora::Rest::Client do
  context 'with invalid credentials' do
    let(:username) { 'bad' }
    let(:password) { 'bad' }
    let(:client) do
      VCR.use_cassette('rest/auth_failure') do
        Zuora::Rest::Client.new username, password, true
      end
    end

    it 'fails to authenticate' do
      expect { client }.to raise_exception(Zuora::Rest::ConnectionError)
    end
  end

  context 'with valid credentials' do
    let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
    let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
    let(:client) do
      VCR.use_cassette('rest/auth_success') do
        Zuora::Rest::Client.new username, password, true
      end
    end

    it 'authenticates without error' do
      expect { client }.to_not raise_exception
    end

    context 'with rate limiting' do
      let(:client) do
        VCR.use_cassette('rest/auth_success_rate_limited') do
          Zuora::Rest::Client.new username, password, true
        end
      end

      before do
        Zuora::RETRY_WAITING_PERIOD = 0.1
      end

      it 'retries the request' do
        expect { client }.to_not raise_exception
      end
    end

    let(:payment_method_id) { '2c92c0f952e407170152f11b73e65d85' }

    context 'with an account' do
      let(:create_account) do
        VCR.use_cassette('rest/create_account') do
          client.post '/rest/v1/accounts',
            name: 'Account Name',
            hpmCreditCardPaymentMethodId: payment_method_id,
            currency: 'USD',
            billCycleDay: '1',
            billToContact: {
              firstName: 'Joe',
              lastName: 'Schmoe',
              country: 'USA'
            }
        end
      end

      let(:account_id) { create_account.body['accountId'] }

      let(:update_account) do
        VCR.use_cassette('rest/update_account') do
          client.put "/rest/v1/accounts/#{account_id}",
            notes: 'Adding some notes'
        end
      end

      let(:get_account) do
        VCR.use_cassette('rest/get_account') do
          client.get "/rest/v1/accounts/#{account_id}"
        end
      end

      let(:delete_payment_method) do
        VCR.use_cassette('rest/delete_payment_method') do
          client.delete "/rest/v1/payment-methods/#{payment_method_id}"
        end
      end

      describe 'POST' do
        it { expect { create_account }.to_not raise_error }
      end

      describe 'PUT' do
        it { expect { update_account }.to_not raise_error }
      end

      describe 'GET' do
        let(:error_text) do
          "Error 50000040: Cannot find entity by key: '2c92c0" \
          "fa52e3f6790152f11fd4fd1fcfx'."
        end
        it { expect { get_account }.to_not raise_error }

        it 'should raise a human-readable exception when an error happens' do
          VCR.use_cassette('rest/get_account_with_error') do
            expect do
              client.get "/rest/v1/accounts/#{account_id}x"
            end.to raise_error(
              Zuora::Rest::ErrorResponse,
              error_text
            )
          end
        end

        it 'should raise a an error with the HTTP status during an outage' do
          VCR.use_cassette('rest/get_account_500_error') do
            expect do
              client.get "/rest/v1/accounts/#{account_id}"
            end.to raise_error(
              Zuora::Rest::ErrorResponse,
              'HTTP Status 500'
            )
          end
        end
      end

      describe 'DELETE' do
        it { expect { delete_payment_method }.to_not raise_error }
      end

      describe 'Invalid Requests' do
        let(:invoice_id) { '2c92c0945e550c38015e592bdbb57faf' }
        it 'should raise a an error when an invoice does not exist' do
          VCR.use_cassette('rest/update_invoice_error') do
            expect do
              client.put "/rest/v1/object/invoice/#{invoice_id}",
                {"Status": "Canceled"}
            end.to raise_error(
              Zuora::Rest::ErrorResponse,
              'Error INVALID_ID: invalid id for update'
            )
          end
        end

        it 'should raise a an error when bad parameters for cancel present' do
          VCR.use_cassette('rest/cancel_subscription_error') do
            expect do
              client.put "/rest/v1/subscriptions/1234567890/cancel",
                {"cancellationEffectiveDate": "2019-05-31",
                  "cancellationPolicy": "SpecificDate",
                  "invoice": true,
                  "collect": false}
            end.to raise_error(
              Zuora::Rest::ErrorResponse,
              "Error 53200021: Invalid parameter(s): 'invoice,collect'."
            )
          end
        end

        it 'should raise a an error when bad parameters for cancel present' do
          VCR.use_cassette('rest/update_account_error') do
            expect do
              client.put "/rest/v1/action/update",
                {
                  "objects":[{
                    "Id":"2c93808457d787030157e0321fdf4fab",
                    "DefaultPaymentMethodId":"2c93808457d787030157e03220ec4fad",
                    "Status":"Active"
                  }],
                  "type":"Account"
                }
            end.to raise_error(
              Zuora::Rest::ErrorResponse,
              "Error INVALID_ID: invalid id for update"
            )
          end
        end
      end
    end
  end
end
