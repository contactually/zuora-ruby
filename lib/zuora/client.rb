require 'faraday'
require 'faraday_middleware'
require 'nokogiri'

module Zuora
  # Unable to connect. Check username / password
  SoapConnectionError = Class.new StandardError

  # Non-success response
  SoapErrorResponse = Class.new StandardError

  class Client
    attr_accessor :session_token

    SOAP_API_URI = '/apps/services/a/74.0'.freeze
    SESSION_TOKEN_XPATH =
      %w(//soapenv:Envelope soapenv:Body ns1:loginResponse
         ns1:result ns1:Session).join('/').freeze

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
    end

    # Makes auth request, handles response
    # @return [Faraday::Response]
    def authenticate!
      auth_response = call! :login,
        username: @username,
        password: @password

      handle_auth_response auth_response
    rescue Object => e
      raise SoapConnectionError, e
    end

    # Fire a request
    # @param [Xml] body - an object responding to .xml
    # @return [Faraday::Response]
    def request!(body)
      fail 'body must support .to_xml' unless body.respond_to? :to_xml

      connection.post do |request|
        request.url SOAP_API_URI
        request.headers['Content-Type'] = 'text/xml'
        request.body = body.to_xml
      end
    end

    # The primary interface via which users should make SOAP requests.
    # client.call :create, object_name: :BillRun, data: {...}
    # client.call :subscribe, account: {...}, sold_to_contact: {...}
    # @param [Symbol] call_name - one of :create, :subscribe, :amend, :update
    # @return [Faraday:Response] - response
    def call!(call_name, *args)
      factory = call_factory(call_name)
      xml_builder = factory.new(*args).xml_builder
      request_data = envelope_for call_name, xml_builder
      request! request_data
    end

    private

    # Generate envelope for request
    # @param [Symbol] call name - one of the supported calls (see #call)
    # @param [Callable] builder_modifier - function taking a builder
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

    # Maps a SOAP call name and args to its coresponding class.
    # @params [Symbol] call name
    # @return [Faraday::Response]
    # @throw [SoapErrorResponse]
    def call_factory(call_name)
      case call_name
      when :create then Zuora::Calls::Create
      when :login then Zuora::Calls::Login
      when :subscribe then Zuora::Calls::Subscribe
      when :amend then Zuora::Calls::Amend
      else
        fail "Unknown SOAP API call name: #{call_name}.
              Must be one of :create, :login, subscribe, :amend, :delete."
      end
    end

    # Handle auth response, setting session
    # @params [Faraday::Response]
    # @return [Faraday::Response]
    # @throw [SoapErrorResponse]
    def handle_auth_response(response)
      if response.status == 200
        @session_token = extract_session_token response
      else
        message = 'Unable to connect with provided credentials'
        fail SoapErrorResponse, message
      end
      response
    end

    # Extracts session token from response and sets instance variable
    # for use in subsequent requests
    # @param [Faraday::Response] response - response to auth request
    def extract_session_token(response)
      Nokogiri::XML(response.body).xpath(
        SESSION_TOKEN_XPATH, Zuora::NAMESPACES
      ).text
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
