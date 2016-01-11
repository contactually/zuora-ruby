require 'spec_helper'

if !ENV || ENV['ZUORA_SANDBOX_USERNAME'].nil? || ENV['ZUORA_SANDBOX_PASSWORD'].nil?
  raise 'Please set ZUORA_SANDBOX_USERNAME and ZUORA_SANDBOX_PASSWORD in .env'
end

describe 'Sign up a customer' do
  let(:customer) { build :contact }
  let(:credit_card) { build :credit_card }

  let(:account) do
    build :account,
          :sold_to_contact => customer,
          :bill_to_contact => customer,
          :credit_card => credit_card
  end


  it { expect(account).to be_valid }

  let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
  let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
  let(:client) { Zuora::Client.new username, password, true }
  let(:serializer) { Zuora::Serializers::Attribute }
  let(:account_response) { Zuora::Resources::Accounts.create! client, account, serializer }

  it { expect(account_response.status).to eq 200 }

  ##

  ## Todo, Subscribe to a ProductRatePlan
end