require 'faraday'
require 'faraday_middleware'
require 'nokogiri'

module Zuora
  # Unable to connect. Check username / password
  SoapConnectionError = Class.new StandardError

  # Non-success response
  SoapErrorResponse = Class.new StandardError

  module Soap
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
        auth_response(
          request(
            Zuora::Soap::Calls::Login.xml_builder(
              @username,
              @password
            )
          )
        )
      rescue Object => e
        raise SoapConnectionError, e
      end

      REFUND_FIELDS = [
        :AccountId,
        :Amount,
        :PaymentId,
        :Type
      ].freeze

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

      Z_OBJECTS = { Refund: REFUND_FIELDS,
                    BillRun: BILL_RUN_FIELDS }.freeze

      # Dynamically generates methods that create zobject xml
      Z_OBJECTS.each do |z_object_name, fields|
        object_name = z_object_name.to_s.underscore
        create_xml_method_name = "create_#{object_name}_xml"
        create_request_method_name = "create_#{object_name}!"

        # Generates XML builder for given Z-object using data
        # @params [Hash] data - hash of data for the new z-object
        define_method(create_xml_method_name) do |data = {}|
          Zuora::Soap::Calls::Create.xml_builder(
            @session_token,
            z_object_name,
            fields,
            data
          )
        end

        # Fires a create ___ request sending XML envelope for Z-Object
        # @params [Hash] data - hash of data for the new z-object
        # @return [Faraday::Response]
        define_method(create_request_method_name) do |data = {}|
          request send(create_xml_method_name, data)
        end
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
        Nokogiri::XML(response.body)
          .xpath(SESSION_TOKEN_XPATH, Zuora::Soap::NAMESPACES)
          .text
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
end
