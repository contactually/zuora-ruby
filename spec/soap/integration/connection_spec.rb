require 'spec_helper'
require 'nokogiri'

describe Zuora::Soap::Client do
  let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
  let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
  let(:vcr_options) { { match_requests_on: [:path] } }
  let(:client) { Zuora::Soap::Client.new(username, password, true) }

  let(:soap_success_xpath) do
    '/soapenv:Envelope/soapenv:Body/ns1:createResponse/ns1:result/ns1:Success'
  end

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

  # Zuora Z-Object Integration Tests

  ## BILL RUN
  describe 'handles bill run use cases' do
    let(:valid_bill_run_opts) do
      {
        target_date: '2016-03-01',
        invoice_date: '2016-03-01'
      }
    end

    let(:invalid_bill_run_opts) { {} }

    let!(:create_bill_run_success_response) do
      VCR.use_cassette('soap_create_bill_run_success', vcr_options) do
        client.call!(:create, object_type: :BillRun, data: valid_bill_run_opts)
      end
    end

    let(:create_bill_run_success_status) do
      Nokogiri::XML(create_bill_run_success_response.body).xpath(
        soap_success_xpath, Zuora::Soap::NAMESPACES
      ).text
    end

    let!(:create_bill_run_failure_response) do
      VCR.use_cassette('soap_create_bill_run_failure', vcr_options) do
        client.call!(
          :create,
          object_type: :BillRun,
          data: invalid_bill_run_opts
        )
      end
    end

    let(:create_bill_run_failure_status) do
      Nokogiri::XML(create_bill_run_failure_response.body).xpath(
        soap_success_xpath, Zuora::Soap::NAMESPACES
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

  ## Refund
  describe 'handles refund run use cases' do
    let(:valid_refund_opts) do
      {
        amount: 5,
        comment: 'Five dollas back',
        type: 'Electronic',
        payment_id: '2c92c0945239b44f01523de2ce0a6e7b'
      }
    end

    let(:invalid_refund_opts) { {} }

    let(:parse_success) do
      lambda do |xml|
        Nokogiri::XML(xml).xpath(
          soap_success_xpath, Zuora::Soap::NAMESPACES
        ).text
      end
    end

    let!(:create_refund_success_response) do
      VCR.use_cassette('soap_create_refund_success', vcr_options) do
        client.call!(:create, object_type: :Refund, data: valid_refund_opts)
      end
    end

    let(:create_refund_success_status) do
      parse_success.call(create_refund_success_response.body)
    end

    let!(:create_refund_failure_response) do
      VCR.use_cassette('soap_create_refund_failure', vcr_options) do
        client.call!(:create, object_type: :Refund, data: invalid_refund_opts)
      end
    end

    let(:create_refund_failure_status) do
      Nokogiri::XML(create_refund_failure_response.body).xpath(
        soap_success_xpath, Zuora::Soap::NAMESPACES
      ).text
    end

    it 'successfully creates a refund' do
      expect(create_refund_success_response.status).to eq 200
      expect(create_refund_success_status).to eq 'true'
    end

    it 'fails to create an invalid refund' do
      expect(create_refund_success_response.status).to eq 200
      expect(create_refund_failure_status).to eq 'false'
    end
  end
end
