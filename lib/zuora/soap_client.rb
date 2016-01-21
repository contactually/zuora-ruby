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

    SOAP_API_URI = '/apps/services/a/74.0'.freeze
    SESSION_TOKEN_XPATH =
      %w(//soapenv:Envelope soapenv:Body ns1:loginResponse
         ns1:result ns1:Session).join('/').freeze

    NAMESPACES = {
      'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/',
      'xmlns:ns1' => 'http://api.zuora.com/',
      'xmlns:ns2' => 'http://object.api.zuora.com/',
      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
    }.freeze

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
      auth_response(request(login_request_xml))
    rescue Object => e
      raise SoapConnectionError, e
    end

    # Fires a create bill run request
    # @params [Hash] opts - one or more BillRun create fields
    # @return [Faraday::Response]
    def create_bill_run!(opts)
      request create_bill_run_xml(opts)
    end

    private

    # Fire a request
    # @param [Xml] body - an object responding to .xml
    # @return [Faraday::Response]
    def request(body)
      fail 'body must support .to_xml' unless body.respond_to? :to_xml

      connection.post do |request|
        request.url SOAP_API_URI
        request.headers['Content-Type'] = 'text/xml'
        request.body = body.to_xml
      end
    end

    # Handle auth response, setting session
    # @params [Faraday::Response]
    # @return [Faraday::Response]
    # @throw [SoapErrorResponse]
    def auth_response(response)
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
      Nokogiri::XML(response.body).xpath(SESSION_TOKEN_XPATH, NAMESPACES).text
    end

    # Generates Login Envelope XML builder
    def login_request_xml
      username = @username
      password = @password

      body = lambda do |builder|
        builder[:ns1].login do
          builder[:ns1].username(username)
          builder[:ns1].password(password)
        end
        builder
      end

      envelope_xml nil, body
    end

    BILL_RUN_FIELDS = [
      :AccountId,
      :AutoEmail,
      :AutoPost,
      :AutoRenewal,
      :Batch,
      :BillCycleDay,
      :ChargeTypeToExclude,
      :Id,
      :InvoiceDate,
      :NoEmailForZeroAmountInvoice,
      :Status,
      :TargetDate
    ].freeze

    # Builds a field if its value exists in opts
    # @params [Nokogiri::XML::Builder] opts - one or more BillRun create fields
    # @params [Hash] opts - one or more BillRun create fields
    # @params [Symbol] field - an upper-camel-cased Symbol
    # @return [Nokogiri::XML::Builder]
    def build_field(builder, opts, field)
      snake_case_field = field.to_s.underscore.to_sym
      value = opts[snake_case_field]
      builder[:ns2].send(field, value) if value
      builder
    end

    # Generates BillRun Envelope XML builder
    # @params [Hash] opts - one or more BillRun create fields
    # @return [Nokogiri::XML::Builder]
    def create_bill_run_xml(opts = {})
      authenticated_envelope_xml do |builder|
        builder[:ns1].create do
          builder[:ns1].zObjects('xsi:type' => 'ns2:BillRun') do
            BILL_RUN_FIELDS.each do |field|
              build_field builder, opts, field
            end
          end
        end
      end
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

    # Takes a body, and returns an envelope with session header token merged in
    # @param [Callable] body - function of body
    # @return [Nokogiri::Xml::Builder]
    def authenticated_envelope_xml(&body)
      failure_message = 'Session token not set. Did you call authenticate? '
      fail failure_message unless @session_token.present?

      token = @session_token

      header = lambda do |builder|
        builder[:ns1].SessionHeader do
          builder[:ns1].session(token)
        end
        builder
      end

      envelope_xml(header, body)
    end

    # @param [Callable] header - optional function of builder, returns builder
    # @param [Callable] body  - optional function of builder, returns builder
    def envelope_xml(header, body)
      builder = Nokogiri::XML::Builder.new
      builder[:soapenv].Envelope(NAMESPACES) do
        builder[:soapenv].Header do
          header.call builder
        end if header
        builder[:soapenv].Body do
          body.call builder
        end if body
      end
      builder
    end
  end
end
