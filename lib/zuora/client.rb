require 'faraday'
require 'faraday_middleware'
require 'json'

module Zuora
  # Unable to connect. Check username / password
  ConnectionError = Class.new StandardError

  # Non-success response
  ErrorResponse = Class.new StandardError

  class Client
    attr_reader :connection

    # Creates a connection instance.
    # Makes an initial HTTP request to fetch session token.
    # Subsequent requests made with .get, .post, and .put
    # contain the authenticated session id in their headers.
    # @param [String] username
    # @param [String] password
    # @param [Boolean] sandbox
    # @return [Zuora::Client] with .connection, .put, .post
    def initialize(username, password, sandbox = false)
      base_url = api_url sandbox
      conn = connection base_url

      response = auth_request conn, username, password

      handle_response response, conn
    end

    # @param [String] url - URL of request
    # @return [Faraday::Response] A response, with .headers, .status & .body
    def get(url)
      @connection.get do |req|
        set_request_headers! req, url
      end
    end

    # # @param [String] url - URL for HTTP POST request
    # # @param [Params] object - Object to be sent in request body
    # # @return [Faraday::Response] A response, with .headers, .status & .body
    [:post, :put].each do |http_method|
      define_method(http_method) do |url, object|
        @connection.send(http_method) do |request|
          set_request_headers! request, url
          request.body = JSON.generate object.to_json
        end
      end
    end

    private

    # Make connection attempt
    # @param [Faraday::Connection] conn
    # @param [String] username
    # @param [String] password
    def auth_request(conn, username, password)
      conn.post do |request|
        set_auth_request_headers! request, username, password
      end
    end

    # Sets instance variables or throws Connection error
    # @param [Faraday::Response] response
    # @param [Faraday::Connection] conn
    def handle_response(response, conn)
      if response.status == 200
        @auth_cookie = response.headers['set-cookie'].split(' ')[0]
        @connection = conn
      else
        fail ConnectionError, response.body['reasons']
      end
    end

    # @param [Faraday::Request] request - Faraday::Request builder
    # @param [String] username - Zuora username
    # @param [String] password - Zuora password
    def set_auth_request_headers!(request, username, password)
      request.url '/rest/v1/connections'
      request.headers['apiAccessKeyId'] = username
      request.headers['apiSecretAccessKey'] = password
      request.headers['Content-Type'] = 'application/json'
    end

    # @param [Faraday::Request] request - Faraday Request builder
    # @param [String] url - Relative URL for HTTP request
    # @return [Nil]
    def set_request_headers!(request, url)
      request.url url
      request.headers['Content-Type'] = 'application/json'
      request.headers['Cookie'] = @auth_cookie
    end

    # @param [String] url
    # @return [Faraday::Client]
    def connection(url)
      Faraday.new(url, ssl: { verify: false }) do |conn|
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.use :instrumentation
        conn.adapter Faraday.default_adapter
      end
    end

    # @param [Boolean] sandbox - Use the sandbox url?
    # @return [String] the API url
    def api_url(sandbox)
      if sandbox
        Zuora::SANDBOX_URL
      else
        Zuora::API_URL
      end
    end
  end
end
