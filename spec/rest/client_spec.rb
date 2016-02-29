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
        it { expect { get_account }.to_not raise_error }
      end

      describe 'DELETE' do
        it { expect { delete_payment_method }.to_not raise_error }
      end
    end
  end
end
