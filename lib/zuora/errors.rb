# frozen_string_literal: true

module Zuora
  module Errors
    GenericError = Class.new(StandardError)

    class InvalidValue < GenericError
      attr_reader :response

      def initialize(msg = nil, response = nil)
        @response = response
        super(msg)
      end
    end

    class InvalidCredentials < GenericError
    end

    class SoapConnectionError < GenericError
    end
  end
end
