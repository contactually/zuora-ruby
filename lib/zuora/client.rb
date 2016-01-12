# encoding: utf-8
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

      response = conn.post do |req|
        set_auth_request_headers! req, username, password
      end

      if response.status == 200
        @auth_cookie = response.headers['set-cookie'].split(' ')[0]
        @connection = conn
      else
        fail ConnectionError, response.body['reasons']
      end
    end

    # @param [String] url - URL of request
    # @return [Faraday::Response] A response, with .headers, .status & .body
    def get(url)
      @connection.get do |req|
        set_request_headers! req, url
      end
    end

    # @param [String] url - URL for HTTP POST request
    # @param [Params] params - Data to be sent in request body
    # @return [Faraday::Response] A response, with .headers, .status & .body
    def post(url, params)
      response = @connection.post do |req|
        set_request_headers! req, url
        req.body = JSON.generate params
      end

      response
      # if response.body['success']
      #  return response
      # else
      #  raise ErrorResponse.new(response)
      # end
    end

    # @param [String] url - URL for HTTP PUT request
    # @param [Params] params - Data to be sent in request body
    # @return [Faraday::Response] A response, with .headers, .status & .body
    def put(url, params)
      response = @connection.put do |req|
        set_request_headers! req, url
        req.body = JSON.generate params
      end

      response
      # if response.body['success']
      #  return response
      # else
      #  raise ErrorResponse.new(response)
      # end
    end

    private

    # @param [Faraday::Request] req - Faraday::Request builder
    # @param [String] username - Zuora username
    # @param [String] password - Zuora password
    def set_auth_request_headers!(req, username, password)
      req.url '/rest/v1/connections'
      req.headers['apiAccessKeyId'] = username
      req.headers['apiSecretAccessKey'] = password
      req.headers['Content-Type'] = 'application/json'
    end

    # @param [Faraday::Request] request - Faraday Request builder
    # @param [String] url - Relative URL for HTTP request
    # @return [Nil]
    def set_request_headers!(req, url)
      req.url url
      req.headers['Content-Type'] = 'application/json'
      req.headers['Cookie'] = @auth_cookie
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
