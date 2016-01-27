module Zuora
  module Soap
    module Calls
      class Login < Hashie::Dash
        # @params [String] username
        # @params [String] password
        property :username, required: true
        property :password, required: true

        # Generates Login Envelope XML builder
        # @return [Nokogiri::XML::Builder]
        def xml_builder
          body = lambda do |builder|
            builder[:ns1].login do
              builder[:ns1].username(username)
              builder[:ns1].password(password)
            end
            builder
          end

          Zuora::Soap::Utils::Envelope.xml nil, body
        end
      end
    end
  end
end
