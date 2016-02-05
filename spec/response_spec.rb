require 'spec_helper'

describe Zuora::Response do
  describe '#handle_errors' do
    let(:response_hash) do
      {
        'envelope' => {
          'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/',
          'body' => {
            'subscribe_response' => {
              'xmlns:ns1' => 'http://api.zuora.com/',
              'result' => {
                'account_id' => {
                  'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                  'xsi:nil' => '1'
                },
                'account_number' => {
                  'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                  'xsi:nil' => '1'
                },
                'errors' => {
                  'code' => 'INVALID_VALUE',
                  'message' =>
                    'Can not process payments if Payment Method is null'
                },
                'invoice_id' => {
                  'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                  'xsi:nil' => '1'
                }
              }
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
