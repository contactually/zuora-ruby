require 'spec_helper'
require 'nokogiri'

describe Zuora::SoapClient do
  let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
  let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
  let(:client) { Zuora::SoapClient.new(username, password, true) }
  let(:response) { client.authenticate! }

  it { expect(response.status).to eq 200 }
  it { response; expect(client.session_token).to_not be_nil }
end