require 'spec_helper'

describe Zuora::Response do
  describe '#handle_errors' do
    let(:response_hash) do
      { 'envelope' =>
          {
            'soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/',
            'body' => {
              'create_response' => {
                'ns1' => 'http://api.zuora.com/',
                'result' => [
                  {
                    'errors' => {
                      'code' => 'INVALID_VALUE',
                      'message' =>
                        'The Invoice Item can only be adjusted toward zero.'
                    },
                    'success' => 'false'
                  },
                  {
                    'errors' => {
                      'code' => 'INVALID_VALUE',
                      'message' =>
                        'The Invoice Item can only be adjusted toward zero.'
                    },
                    'success' => 'false'
                  }
                ]
              }
            }
          }
      }
    end
    let(:response) { Zuora::Response.new(Faraday::Response.new) }

    before do
      hashie = Hashie::Mash.new(response_hash)
      allow(response).to receive(:to_h).and_return(hashie)
    end

    subject { response.handle_errors(response.to_h) }

    it 'raises errors' do
      expect { subject }.to raise_error(Zuora::Errors::InvalidValue)
    end
  end
end
