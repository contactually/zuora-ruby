require 'spec_helper'

if ENV['ZUORA_SANDBOX_USERNAME'].nil? || ENV['ZUORA_SANDBOX_PASSWORD'].nil?
  fail 'Please set ZUORA_SANDBOX_USERNAME and ZUORA_SANDBOX_PASSWORD in .env'
end

describe 'Sign up a customer' do
  # Authentication
  let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
  let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
  let(:client) { Zuora::Client.new username, password, true }

  # Models
  let(:customer) { build :contact }
  let(:credit_card) { build :credit_card }

  let(:account) do
    build :account,
      sold_to_contact: customer,
      bill_to_contact: customer,
      credit_card: credit_card
  end

  let(:subscription) do
    build :subscription,
      account_key: account.account_number
  end

  # Serializer

  let(:serializer) { Zuora::Serializers::Attribute }

  # Resource requests
  let(:account_create_response) do
    VCR.use_cassette('account_create!') do
      Zuora::Resources::Accounts.create! client, account, serializer
    end
  end

  let(:subscription_create_response) do
    VCR.use_cassette('subscription_create!') do
      Zuora::Resources::Subscriptions.create! client, subscription, serializer
    end
  end

  let(:account_update_response) do
    VCR.use_cassette('account_update!') do
      Zuora::Resources::Accounts.update! client, account, serializer
    end
  end

  let(:subscription_update_response) do
    VCR.use_cassette('subscription_update!') do
      Zuora::Resources::Subscriptions.update! client, subscription, serializer
    end
  end

  # Expectations
  it { expect(account_create_response.status).to eq 200 }
  it { expect(account_update_response.status).to eq 200 }

  it { expect(subscription_create_response.status).to eq 200 }
  it { expect(subscription_update_response.status).to eq 200 }
end
