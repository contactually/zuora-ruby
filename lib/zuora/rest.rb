module Zuora
  module Rest
    API_URL = 'https://api.zuora.com/rest/v1/'.freeze
    SANDBOX_URL = 'https://apisandbox-api.zuora.com/rest/v1/'.freeze

    # Unable to connect. Check username / password
    ConnectionError = Class.new StandardError

    # Non-success response
    ErrorResponse = Class.new StandardError
  end
end
require_relative 'rest/client'
