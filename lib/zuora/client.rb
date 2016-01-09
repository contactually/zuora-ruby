# encoding: utf-8
require 'faraday'
require 'faraday_middleware'
require 'json'

module Zuora

  ConnectionError = Class.new(StandardError)

  class Client
    attr_accessor :connection

    def initialize(username, password, sandbox=false)
      url = api_url(sandbox)

      connection = Faraday.new(:url => url, :ssl => {:verify => false })

      response = connection.post do |req|
        # Todo: URL prefix should be in base
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

    def get(url)
      @connection.get do |req|
        req.url url
        req.headers['Content-Type'] = 'application/json'
        req.headers['Cookie'] = @auth_cookie
      end
    end

    def post(url, params)
      @connection.post do |req|
        req.url url
        req.headers['Content-Type'] = 'application/json'
        req.headers['Cookie'] = @auth_cookie
        req.body = JSON.generate params
      end
    end

    private

    def api_url(sandbox)
      if sandbox
        Zuora::SANDBOX_URL
      else
        Zuora::API_URL
      end
    end
  end
end
