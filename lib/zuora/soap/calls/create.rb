module Zuora
  module Soap
    module Calls
      module Create
        # Generates a SOAP envelope for given Zuora object
        # of `type`, having `fields`, with `data`
        # @params [String] token
        # @params [Symbol] type e.g. :BillRun, :Refund
        # @params [Array] fields - hash of whitelisted zuora object field names
        # @return [Nokogiri::Xml::Builder] - SOAP envelope
        def self.xml_builder(token, type, fields, data)
          Zuora::Soap::Utils::Envelope.authenticated_xml token do |b|
            b[:ns1].create do
              b[:ns1].zObjects('xsi:type' => "ns2:#{type}") do
                fields.each do |field|
                  value = data[field.to_s.underscore.to_sym]
                  b[:ns2].send(field, value) if value
                end
              end
            end
          end
        end
      end
    end
  end
end
