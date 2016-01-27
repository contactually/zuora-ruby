module Zuora
  module Soap
    module Calls
      class Create < Hashie::Dash
        # @params [String] token
        # @params [Symbol] type e.g. :BillRun, :Refund
        # @params [Array] data - hash of whitelisted zuora object field names
        property :token, required: true
        property :object_type, required: true
        property :data, required: true

        # Generates a SOAP envelope for given Zuora object
        # of `type`, having `fields`, with `data`
        # @return [Nokogiri::XML::Builder] - SOAP envelope
        def xml_builder
          Zuora::Soap::Utils::Envelope.authenticated_xml token do |b|
            b[:ns1].create do
              b[:ns1].zObjects('xsi:type' => "ns2:#{object_type}") do
                Zuora::Soap::Utils::Envelope.build_fields(:ns1, data)
              end
            end
          end
        end
      end
    end
  end
end
