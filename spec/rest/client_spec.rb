require 'spec_helper'

if ENV['ZUORA_SANDBOX_USERNAME'].nil? || ENV['ZUORA_SANDBOX_PASSWORD'].nil?
  fail 'Please set ZUORA_SANDBOX_USERNAME and ZUORA_SANDBOX_PASSWORD in .env'
end

describe 'Sign up a customer' do
  context 'with valid credentials' do
    let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
    let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
    let(:client) do
      VCR.use_cassette('rest/auth_success') do
        Zuora::Rest::Client.new username, password, true
      end
    end

    it { expect { client }.to_not raise_exception }
  end

  context 'with invalid credentials' do
    let(:username) { 'bad' }
    let(:password) { 'bad' }
    let(:client) do
      VCR.use_cassette('rest/auth_failure') do
        Zuora::Rest::Client.new username, password, true
      end
    end

    it { expect { client }.to raise_exception }
  end
end
