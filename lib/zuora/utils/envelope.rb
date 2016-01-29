module Zuora
  module Utils
    module Envelope
      # @param [Callable] header - optional function of builder, rtns builder
      # @param [Callable] body  - optional function of builder, rtns builder
      def self.xml(header, body)
        Nokogiri::XML::Builder.new do |builder|
          builder[:soapenv].Envelope(Zuora::NAMESPACES) do
            builder[:soapenv].Header do
              header.call builder
            end if header
            builder[:soapenv].Body do
              body.call builder
            end if body
          end
        end
      end

      # Takes a body, and returns an envelope with session token merged in
      # @param [Callable] body - function of body
      # @return [Nokogiri::XML::Builder]
      def self.authenticated_xml(token, &body)
        failure_message = 'Session token not set. Did you call authenticate?'
        fail failure_message unless token.present?

        header = lambda do |builder|
          builder[:api].SessionHeader do
            builder[:api].session(token)
          end
          builder
        end

        xml(header, body)
      end

      # Builds multiple fields
      # @param [Nokogiri::XML::Builder] builder
      # @param [Symbol] namespace
      # @param [Hash] object
      # @return nil
      def self.build_fields(builder, namespace, object = {})
        object.each do |key, value|
          zuora_field_name = to_zuora_key(key)
          builder[namespace].send(zuora_field_name, value) unless value.nil?
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

      # Converts from Zuora key format to Ruby format
      # @param [Symbol] key - e.g. :some_key_name
      # @return [Symbol] - e.g. :SomeKeyName
      def self.to_zuora_key(key)
        transform_sym key, :camelize
      end

      # Converts from Ruby to Zuora key format
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
