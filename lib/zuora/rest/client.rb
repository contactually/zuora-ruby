# encoding: utf-8
require 'faraday'
require 'faraday_middleware'
require 'json'

module Zuora
  module Rest
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

        response = conn.post do |req|
          set_auth_request_headers! req, username, password
        end

        case response.status
        when 200
          @auth_cookie = response.headers['set-cookie'].split(' ')[0]
          @connection = conn
        when 429
          sleep(Zuora::RETRY_WAITING_PERIOD)
          return initialize(username, password, sandbox)
        else
          fail Zuora::Rest::ConnectionError, response.body['reasons']
        end
      end

      # @param [String] url - URL of request
      # @return [Faraday::Response] A response, with .headers, .status & .body
      [:get, :delete].each do |method|
        define_method(method) do |url|
          response = @connection.send(method) do |req|
            set_request_headers! req, url
          end

          # Handle rate limiting
          return handle_rate_limiting(method, url) if response.status == 429

          fail_or_response(response)
        end
      end

      # @param [String] url - URL for HTTP POST / PUT request
      # @param [Params] params - Data to be sent in request body
      # @return [Faraday::Response] A response, with .headers, .status & .body
      [:post, :put].each do |method|
        define_method method do |url, params|
          response = @connection.send(method) do |req|
            set_request_headers! req, url
            req.body = JSON.generate params
          end

          # Handle rate limiting
          if response.status == 429
            return handle_rate_limiting(method, url, params)
          end

          fail_or_response(response)
        end
      end

      private

      # @param [String] method
      # @param [String] url
      # @param [Hash] params
      def handle_rate_limiting(method, url, params = nil)
        sleep(Zuora::RETRY_WAITING_PERIOD)
        if params.present?
          send(method, url, params)
        else
          send(method, url)
        end
      end

      # @param [Faraday::Response] response
      # @throw [ErrorResponse] if unsuccessful
      # @return [Faraday::Response]
      def fail_or_response(response)
        success = response.body['success'] && response.status == 200
        fail(ErrorResponse.new('Non-200', response)) unless success
        response
      end

      # @param [Faraday::Request] req - Faraday::Request builder
      # @param [String] username
      # @param [String] password
      def set_auth_request_headers!(req, username, password)
        req.url '/rest/v1/connections'
        req.headers['apiAccessKeyId'] = username
        req.headers['apiSecretAccessKey'] = password
        req.headers['Content-Type'] = 'application/json'
      end

      # @param [Faraday::Request] request - Faraday Request builder
      # @param [String] url - Relative URL for HTTP request
      def set_request_headers!(request, url)
        request.url url
        request.headers['Content-Type'] = 'application/json'
        request.headers['Cookie'] = @auth_cookie
      end

      # @param [String] url
      # @return [Faraday::Client]
      def connection(url)
        Faraday.new(url, ssl: { verify: true }) do |conn|
          conn.request :json
          conn.response :json, content_type: /\bjson$/
          conn.use :instrumentation
          conn.adapter Faraday.default_adapter
        end
      end

      # @param [Boolean] sandbox - Use the sandbox url?
      # @return [String] url
      def api_url(sandbox)
        sandbox ? Zuora::Rest::SANDBOX_URL : Zuora::Rest::API_URL
      end
    end
  end
end
