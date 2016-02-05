module Zuora
  module Errors
    class RequiredValue < StandardError
      attr_reader :response

      def initialize(msg = nil, response = nil)
        @response = response
        super(msg)
      end
    end

    class InvalidCredentials < StandardError
    end

    class SoapConnectionError < StandardError
    end
  end
end
