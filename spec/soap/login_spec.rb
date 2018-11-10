# frozen_string_literal: true

require 'spec_helper'
require 'nokogiri'

describe Zuora::Client do
  let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
  let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
  let(:vcr_options) do
    { match_requests_on: [:path] }
  end
  let(:client) { Zuora::Soap::Client.new(username, password, true) }

  context 'with correct credentials' do
    let(:auth_response) do
      VCR.use_cassette('soap/authentication_success') do
        client
      end
    end

    it 'receives successful auth response' do
      expect { auth_response }.to_not raise_exception
    end

    it 'sets client auth token' do
      auth_response
      expect(client.session_token).to_not be_nil
    end

    context 'with rate ling' do
      let(:auth_response) do
        VCR.use_cassette('soap/authentication_success_rate_limit') do
          client
        end
      end

      before do
        Zuora::RETRY_WAITING_PERIOD = 0.1
      end

      it 'retries the request' do
        expect { auth_response }.to_not raise_exception
      end
    end
  end

  context 'with incorrect credentials' do
    let(:username) { 'INVALID_USERNAME' }

    subject do
      VCR.use_cassette('soap/authentication_failure') do
        client
      end
    end

    it 'raises invalid credentials error' do
      expect { subject }.to raise_error(Zuora::Errors::InvalidCredentials)
    end
  end
end
