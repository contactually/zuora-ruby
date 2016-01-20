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
  let(:customer) { build :contact_hash }
  let(:credit_card) { build :credit_card_hash }

  let(:account) do
    build :account,
      sold_to_contact: customer,
      bill_to_contact: customer,
      credit_card: credit_card
    # optional: Subscription
  end

  let(:account_resource) do
  end

  # Expectations
  # it { expect(account_create_response.status).to eq 200 }
  # it { expect(account_update_response.status).to eq 200 }
  #
  # it { expect(subscription_create_response.status).to eq 200 }
  # it { expect(subscription_update_response.status).to eq 200 }
end
