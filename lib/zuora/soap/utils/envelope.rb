module Zuora
  module Soap
    module Utils
      module Envelope
        # @param [Callable] header - optional function of builder, rtns builder
        # @param [Callable] body  - optional function of builder, rtns builder
        def self.xml(header, body)
          builder = Nokogiri::XML::Builder.new
          builder[:soapenv].Envelope(Zuora::Soap::NAMESPACES) do
            builder[:soapenv].Header do
              header.call builder
            end if header
            builder[:soapenv].Body do
              body.call builder
            end if body
          end
          builder
        end

        # Takes a body, and returns an envelope with session token merged in
        # @param [Callable] body - function of body
        # @return [Nokogiri::XML::Builder]
        def self.authenticated_xml(token, &body)
          failure_message = 'Session token not set. Did you call authenticate?'
          fail failure_message unless token.present?

          header = lambda do |builder|
            builder[:ns1].SessionHeader do
              builder[:ns1].session(token)
            end
            builder
          end

          xml(header, body)
        end
      end
    end
  end
end
