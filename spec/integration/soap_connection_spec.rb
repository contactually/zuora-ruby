require 'spec_helper'
require 'nokogiri'

describe Zuora::SoapClient do
  let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
  let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
  let(:vcr_options) { { match_requests_on: [:path] } }
  let(:client) { Zuora::SoapClient.new(username, password, true) }

  ## AUTHENTICATION
  let!(:auth_response) do
    VCR.use_cassette('soap_authentication', match_requests_on: [:path]) do
      client.authenticate!
    end
  end

  it 'receives successful auth response' do
    expect(auth_response.status).to eq 200
  end

  it 'sets client auth token' do
    expect(client.session_token).to_not be_nil
  end

  ## BILL RUN
  describe 'handles bill run use cases' do
    let(:soap_success_xpath) do
      '/soapenv:Envelope/soapenv:Body/ns1:createResponse/ns1:result/ns1:Success'
    end

    let(:valid_bill_run_opts) do
      {
        target_date: '2016-03-01',
        invoice_date: '2016-03-01'
      }
    end

    let(:invalid_bill_run_opts) { {} }

    let!(:create_bill_run_success_response) do
      VCR.use_cassette('soap_create_bill_run_success', vcr_options) do
        client.create_bill_run!(valid_bill_run_opts)
      end
    end

    let(:create_bill_run_success_status) do
      Nokogiri::XML(create_bill_run_success_response.body).xpath(
        soap_success_xpath, Zuora::SoapClient::NAMESPACES
      ).text
    end

    let!(:create_bill_run_failure_response) do
      VCR.use_cassette('soap_create_bill_run_failure', vcr_options) do
        client.create_bill_run!(invalid_bill_run_opts)
      end
    end

    let(:create_bill_run_failure_status) do
      Nokogiri::XML(create_bill_run_failure_response.body).xpath(
        soap_success_xpath, Zuora::SoapClient::NAMESPACES
      ).text
    end

    it 'successfully creates a bill run' do
      expect(create_bill_run_success_response.status).to eq 200
      expect(create_bill_run_success_status).to eq 'true'
    end

    it 'fails to create an invalid bill run' do
      expect(create_bill_run_success_response.status).to eq 200
      expect(create_bill_run_failure_status).to eq 'false'
    end
  end
end
