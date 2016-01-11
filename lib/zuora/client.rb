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
    attr_accessor :connection

    # Creates a connection instance.
    # Makes an initial HTTP request to fetch session token.
    # Subsequent requests made with .get, .post, and .put
    # contain the authenticated session id in their headers.
    # @param [String] Zuora username
    # @param [String] Zuora Password
    # @param [Boolean] Use sandbox api?
    # @return [Zuora::Client] with .connection, .put, .post,
    def initialize(username, password, sandbox=false)
      url = api_url sandbox

      connection = Faraday.new(url, :ssl => {:verify => false }) do |conn|
        conn.request :json
        conn.response :json, :content_type => /\bjson$/
        conn.use :instrumentation
        conn.adapter Faraday.default_adapter
      end

      response = connection.post do |req|
        req.url '/rest/v1/connections'
        req.headers['apiAccessKeyId'] = username
        req.headers['apiSecretAccessKey'] = password
        req.headers['Content-Type'] = 'application/json'
      end

      if response.status == 200
        @auth_cookie =  response.headers['set-cookie'].split(' ')[0]
        @connection = connection
      else
        raise ConnectionError.new(response)
      end
    end

    # @param [String] URL of request
    # @return [Faraday::Response] A response, with .headers, .status & .body
    def get(url)
      @connection.get do |req|
        req.url url
        req.headers['Content-Type'] = 'application/json'
        req.headers['Cookie'] = @auth_cookie
      end
    end

    # @param [String] URL for HTTP POST request
    # @param [Params] Data to be sent in request body
    # @return [Faraday::Response] A response, with .headers, .status & .body
    def post(url, params)
      response = @connection.post do |req|
        req.url url
        req.headers['Content-Type'] = 'application/json'
        req.headers['Cookie'] = @auth_cookie
        req.body = JSON.generate params
      end

      response
      #if response.body['success']
      #  return response
      #else
      #  raise ErrorResponse.new(response)
      #end
    end

    # @param [String] URL for HTTP PUT request
    # @param [Params] Data to be sent in request body
    # @return [Faraday::Response] A response, with .headers, .status & .body
    def put(url, params)
      response = @connection.put do |req|
        req.url url
        req.headers['Content-Type'] = 'application/json'
        req.headers['Cookie'] = @auth_cookie
        req.body = JSON.generate params
      end

      response
      #if response.body['success']
      #  return response
      #else
      #  raise ErrorResponse.new(response)
      #end
    end

    private

    # @param [Boolean] Use the sandbox url?
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
