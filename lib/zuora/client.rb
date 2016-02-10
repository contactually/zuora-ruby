require 'faraday'
require 'faraday_middleware'
require 'nokogiri'

module Zuora
  class Client
    attr_accessor :session_token

    SOAP_API_URI = '/apps/services/a/74.0'.freeze
    SESSION_TOKEN_XPATH =
      %w(//soapenv:Envelope soapenv:Body api:loginResponse
         api:result api:Session).join('/').freeze

    # Creates a connection instance.
    # Makes an initial SOAP request to fetch session token.
    # Subsequent requests contain the authenticated session id
    # in headers.
    # @param [String] username
    # @param [String] password
    # @param [Boolean] sandbox
    # @return [Zuora::SoapClient]
    def initialize(username, password, sandbox = true)
      @username = username
      @password = password
      @sandbox = sandbox
      authenticate!
    end

    # Fire a request
    # @param [Xml] body - an object responding to .xml
    # @return [Zuora::Response]
    def request!(body)
      fail 'body must support .to_xml' unless body.respond_to? :to_xml

      raw_response = connection.post do |request|
        request.url SOAP_API_URI
        request.headers['Content-Type'] = 'text/xml'
        request.body = body.to_xml
      end

      response = Zuora::Response.new(raw_response)

      response.handle_errors(response.to_h)

      response
    end

    # The primary interface via which users should make SOAP requests.
    # client.call :create, object_name: :BillRun, data: {...}
    # client.call :subscribe, account: {...}, sold_to_contact: {...}
    # @param [Symbol] call_name - one of :create, :subscribe, :amend, :update
    # @return [Faraday:Response] - response
    def call!(call_name, *args)
      factory = Zuora::Dispatcher.send call_name
      xml_builder = factory.new(*args).xml_builder
      request_data = envelope_for call_name, xml_builder
      request! request_data
    end

    private

    # Makes auth request, handles response
    # @return [Faraday::Response]
    def authenticate!
      auth_response = call! :login,
        username: @username,
        password: @password

      handle_auth_response auth_response
    rescue Object => e
      raise Zuora::Errors::SoapConnectionError, e
    end

    # Generate envelope for request
    # @param [Symbol] call_name - one of the supported calls (see #call)
    # @param [Callable] xml_builder_modifier - function taking a builder
    # @return [Nokogiri::XML::Builder]
    def envelope_for(call_name, xml_builder_modifier)
      if call_name == :login
        Zuora::Utils::Envelope.xml(nil, xml_builder_modifier)
      else
        Zuora::Utils::Envelope.authenticated_xml(@session_token) do |b|
          xml_builder_modifier.call b
        end
      end
    end

    # Handle auth response, setting session
    # @params [Faraday::Response]
    # @return [Faraday::Response]
    # @throw [Zuora::Errors::InvalidCredentials]
    def handle_auth_response(response)
      if response.raw.status == 200
        @session_token = extract_session_token response
      else
        message = 'Unable to connect with provided credentials'
        fail Zuora::Errors::InvalidCredentials, message
      end
      response
    end

    # Extracts session token from response and sets instance variable
    # for use in subsequent requests
    # @param [Faraday::Response] response - response to auth request
    def extract_session_token(response)
      response.to_h.envelope.body.login_response.result.session
    end

    # Initializes a connection using api_url
    # @return [Faraday::Connection]
    def connection
      Faraday.new(api_url, ssl: { verify: false }) do |conn|
        conn.adapter Faraday.default_adapter
      end
    end

    # @return [String] - SOAP url based on @sandbox
    def api_url
      if @sandbox
        'https://apisandbox.zuora.com/apps/services/a/74.0'
      else
        'https://api.zuora.com/apps/services/a/74.0'
      end
    end
  end
end
