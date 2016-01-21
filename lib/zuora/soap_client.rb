require 'faraday'
require 'faraday_middleware'
require 'nokogiri'

module Zuora
  # Unable to connect. Check username / password
  SoapConnectionError = Class.new StandardError

  # Non-success response
  SoapErrorResponse = Class.new StandardError

  class SoapClient
    attr_accessor :session_token

    SOAP_API_URI = '/apps/services/a/74.0'
    SESSION_TOKEN_XPATH =
      %w(//soapenv:Envelope soapenv:Body ns1:loginResponse
           ns1:result ns1:Session).join('/')

    NAMESPACES = {
      'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/',
      'xmlns:ns1' => 'http://api.zuora.com/',
      'xmlns:ns2' => 'http://object.api.zuora.com/',
      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
    }

    # Creates a connection instance.
    # Makes an initial SOAP request to fetch session token.
    # Subsequent requests contain the authenticated session id
    # in headers.
    # @param [String] username
    # @param [String] password
    # @param [Boolean] sandbox
    # @return [Zuora::SoapClient]
    def initialize(username, password, sandbox = true)
      @username, @password, @sandbox = username, password, sandbox
    end

    # Makes auth request and sets :session_token
    def authenticate!
      response = auth_response # fires request
      if response.status == 200
        @session_token = extract_session_token response
      else
        message = 'Unable to connect with provided credentials'
        raise SoapErrorResponse.new(message)
      end
      response
    rescue Object => e
      raise SoapConnectionError.new(e)
    end

    def auth_response
      connection.post do |request|
        request.url SOAP_API_URI
        request.headers['Content-Type'] = 'text/xml'
        request.body = login_request_xml.to_xml
      end
    end

    def extract_session_token(response)
      @session_token =
        Nokogiri::XML(response.body)
          .xpath(SESSION_TOKEN_XPATH, NAMESPACES)
          .text
    end

    def login_request_xml
      builder = Nokogiri::XML::Builder.new

      # Without this line, the builder doesn't properly
      # update when instance variables change
      username, password = @username, @password

      builder[:soapenv].Envelope(NAMESPACES) {
        builder[:soapenv].Body  {
          builder[:ns1].login() {
            builder[:ns1].username(username)
            builder[:ns1].password(password)
          }
        }
      }

      builder
    end

    def connection
      Faraday.new(api_url, ssl: { verify: false }) do |conn|
        conn.adapter Faraday.default_adapter
      end
    end

    def api_url
      if @sandbox
        'https://apisandbox.zuora.com/apps/services/a/74.0'
      else
        'https://api.zuora.com/apps/services/a/74.0'
      end
    end
  end
end
