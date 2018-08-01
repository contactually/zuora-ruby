# frozen_string_literal: true

module Zuora
  module Rest
    API_URL = 'https://api.zuora.com/rest/v1/'
    SANDBOX_URL = 'https://apisandbox-api.zuora.com/rest/v1/'

    # Unable to connect. Check username / password
    ConnectionError = Class.new Errors::GenericError

    # Non-success response
    class ErrorResponse < Errors::GenericError
      attr_reader :response

      def initialize(message = nil, response = nil)
        super(message)
        @response = response
      end
    end
  end
end

require_relative 'rest/client'
