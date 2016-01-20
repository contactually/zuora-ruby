require 'spec_helper'

describe 'Sign up a customer' do
  # Authentication
  let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
  let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
  let(:client) { Zuora::Client.new username, password, true }
  let(:contact) { build(:contact) }
  let(:credit_card) { build(:credit_card) }
  let(:account) do
    build(
      :account,
      bill_to_contact: contact,
      sold_to_contact: contact,
      credit_card: credit_card
    )
  end

  context 'with valid data' do
    it 'creates a new customer account' do
      VCR.use_cassette('create_account_success', match_requests_on: [:path]) do
        response = client.post('/rest/v1/accounts', account)
        expect(response.body['success']).to be_truthy
        expect(response.body['accountId'].present?).to be_truthy
      end
    end
  end

  context 'with invalid data' do
    let(:account) do
      build(
        :account,
        account_number: '123456', # invalid account number
        bill_to_contact: contact,
        sold_to_contact: contact,
        credit_card: credit_card
      )
    end

    it 'creates a new customer account' do
      VCR.use_cassette('create_account_failure', match_requests_on: [:path]) do
        response = client.post('/rest/v1/accounts', account)
        expect(response.body['success']).to be_falsey
        expect(response.body['accountId'].present?).to be_falsey
      end
    end
  end
end
