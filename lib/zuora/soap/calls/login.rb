module Zuora
  module Soap
    module Calls
      module Login
        # Generates Login Envelope XML builder
        def self.xml_builder(username, password)
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
