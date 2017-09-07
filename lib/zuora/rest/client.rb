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
      def initialize(username, password, sandbox = false, modern_endpoint = false)
        @modern_endpoint = modern_endpoint
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
          return initialize(username, password, sandbox, modern_endpoint)
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
        if response.status != 200
          fail(ErrorResponse.new("HTTP Status #{response.status}", response))
        elsif response.body.kind_of?(Array)
          if !response.body.first['Success']
            message = parse_legacy_error(response.body.first)
            fail(ErrorResponse.new(message, response))
          end
        elsif response.body.kind_of?(Hash)
          if response.body.key?('success') && !response.body['success']
            message = parse_error(response.body)
            fail(ErrorResponse.new(message, response))
          elsif response.body.key?('Success') && !response.body['Success']
            message = parse_legacy_error(response.body)
            fail(ErrorResponse.new(message, response))
          end
        end
        response
      end

      # For all REST API endpoints that are 2017+
      # @param [Hash] body - the structure containing errors
      # @return [String] message - human readable error message in string format
      def parse_error(body)
        message = ""
        if body['reasons']
          reasons = body['reasons'].map do |reason|
            "Error #{reason['code']}: #{reason['message']}"
          end
          message += reasons.join(', ')
        end
        message
      end

      # For all REST API endpoints that use the SOAP api behind the scenes,
      # such as ones starting with /v1/object/, the error formatting is different
      # @param [Hash] body - the structure containing errors
      # @return [String] human readable error message in string format
      def parse_legacy_error(body)
        message = ""
        if body['Errors']
          errors = body['Errors'].map do |error|
            "Error #{error['Code']}: #{error['Message']}"
          end
          message += + errors.join(', ')
        end
        message
      end

      # @param [Faraday::Request] req - Faraday::Request builder
      # @param [String] username
      # @param [String] password
      def set_auth_request_headers!(req, username, password)
        if use_modern_rest?
          req.url '/v1/connections'
        else
          req.url '/rest/v1/connections'
        end
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

        if ENV['ZUORA_API_VERSION'].present?
          request.headers['zuora-version'] = ENV['ZUORA_API_VERSION']
        end
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
        if use_modern_rest?
          sandbox ? Zuora::Rest::NEWEST_SANDBOX_URL : Zuora::Rest::NEWEST_API_URL
        else
          sandbox ? Zuora::Rest::SANDBOX_URL : Zuora::Rest::API_URL
        end
      end

      # @return [Boolean]
      def use_modern_rest?
        @modern_endpoint == true
      end
    end
  end
end
