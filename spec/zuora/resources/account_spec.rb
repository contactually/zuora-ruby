require 'spec_helper'

describe Zuora::Accounts do
    describe ::Create do
    let(:model) { SchemaModelSpec.new account_key: 1, label: 'Hello' }

    # Authentication
    let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
    let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
    let(:client) { Zuora::Client.new username, password, true }

    let(:subject) { ResourceModelSpec.new client, model }

    let(:url) { 'https://apisandbox-api.zuora.com/rest/v1/accounts/1'}
    let(:meth) { :get }

    it { expect(subject.url).to eq url }
    it { expect(subject.request_method).to eq meth }
    it { expect(subject.exec!.status).to eq 200 }
  end
end
