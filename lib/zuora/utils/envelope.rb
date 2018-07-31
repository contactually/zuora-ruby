# frozen_string_literal: true

module Zuora
  module Utils
    module Envelope
      CUSTOM_FIELD_STRING = '__c'

      # @param [Callable] header - optional function of builder, rtns builder
      # @param [Callable] body  - optional function of builder, rtns builder
      def self.xml(header, body)
        Nokogiri::XML::Builder.new do |builder|
          builder[:soapenv].Envelope(Zuora::NAMESPACES) do
            builder[:soapenv].Header { header.call builder } if header
            builder[:soapenv].Body { body.call builder } if body
          end
        end
      end

      # Takes a body, and returns an envelope with session token merged in
      # @param [Callable] body - function of body
      # @return [Nokogiri::XML::Builder]
      def self.authenticated_xml(token, &body)
        failure_message = 'Session token not set. Did you call authenticate?'
        raise failure_message unless token.present?

        header = lambda do |builder|
          builder[:api].SessionHeader { builder[:api].session(token) }
          builder
        end

        xml(header, body)
      end

      # Builds one field using key and value. Treats value differently:
      #   - Hash: recursively builds fields
      #   - ZObject: builds a nested z object, building fields inside
      #   - Nil: does nothing
      #   - Else: builds the field node
      # @param [Nokogiri::XML::Builder] builder
      # @param [Symbol] namespace
      # @param [Hash] key
      # @param [Hash|Zuora::Soap::ZObject|NilClass|Object] value
      # @return nil
      def self.build_field(builder, namespace, key, value)
        zuora_field_name = to_zuora_key(key)
        build_fields_thunk = -> { build_fields builder, namespace, value }
        case value
        when Hash
          builder[namespace].send(zuora_field_name) { build_fields_thunk[] }
        when Zuora::Soap::ZObject
          zuora_type = to_zuora_key(value.type)
          xsi = { 'xsi:type' => "obj:#{zuora_type}" }
          builder[:api].send(zuora_field_name) do
            builder[:api].send(zuora_type, xsi) { build_fields_thunk[] }
          end
        when NilClass
        else
          builder[namespace].send(zuora_field_name, value)
        end
      end

      # Builds multiple fields in given object
      # @param [Nokogiri::XML::Builder] builder
      # @param [Symbol] namespace
      # @param [Hash] object
      # @return nil
      def self.build_fields(builder, namespace, object = {})
        object.each do |key, value|
          build_field builder, namespace, key, value
        end
      end

      # Builds multiple objects
      # @param [Nokogiri::XML::Builder] builder
      # @param [Symbol] type
      # @param [Array[Hash]] objects
      # @return nil
      def self.build_objects(builder, type, objects)
        objects.each do |object|
          builder[:api].zObjects('xsi:type' => "obj:#{type}") do
            Zuora::Utils::Envelope.build_fields(builder, :obj, object)
          end
        end
      end

      # Converts from Ruby to Zuora key format.
      # @param [Symbol] key - e.g. :some_key_name or :some_key_name__c
      # @return [Symbol] - e.g. :SomeKeyName or :SomeKeyName__c
      def self.to_zuora_key(key)
        custom_field_matcher = Regexp.new CUSTOM_FIELD_STRING
        matches = custom_field_matcher.match(key.to_s)
        suffix = ''

        if matches
          key = key.to_s[0...-3].to_sym
          suffix = CUSTOM_FIELD_STRING
        end

        key = transform_sym key, :camelize

        [key.to_s, suffix].join.to_sym
      end

      # Converts from Zuora key format to Ruby format.
      # @param [Symbol] key  e.g. :SomeKeyName
      # @return [Symbol] - e.g. :some_key_name
      def self.from_zuora_key(key)
        transform_sym key, :lower
      end

      # Transforms symbol as if were a string, using operation.
      # Helper method for building specific symbol converters.
      # @param [Symbol] - operation
      # @param [Symbol] - symbol
      def self.transform_sym(sym, operation)
        sym.to_s.send(operation).to_sym
      end
    end
  end
end
