module Zuora
  module Calls
    class Login < Hashie::Dash
      # @params [String] username
      # @params [String] password
      property :username, required: true
      property :password, required: true

      # Generates a function that adds login fields to a buidler
      # @return [Callable] builder - a function of builder
      def xml_builder
        lambda do |builder|
          builder[:ns1].login do
            builder[:ns1].username(username)
            builder[:ns1].password(password)
          end
        end
      end
    end
  end
end
