require 'active_support/core_ext/hash/conversions'

module Zuora
  class Response
    ERROR_STRINGS = ['Missing required value', 'are required fields'].freeze
    attr_reader :raw

    # @param [Faraday::Response]
    # @return [Zuora::Response]
    def initialize(response)
      @raw = response
    end

    # Convert XML body to object-like nested hash.
    # @return [Hashie::Mash] object-like nested hash
    def to_h
      doc = Nokogiri::XML raw.body
      hash = Hash.from_xml doc.to_xml
      Hashie::Mash.new(symbolize_keys_deep(hash))
    end

    # @param [Hash] hash
    def handle_errors(hash)
      errors = []

      hash.each do |key, value|
        if value.is_a?(Hash)
          handle_errors(value)
        elsif value.is_a?(Array)
          value.each { |v| handle_errors(v) }
        else
          errors << value if error?(key, value)
        end
      end

      raise_errors(errors) if errors.present?
    end

    private

    # @param [String|Symbol] key
    # @param [String] value
    def error?(key, value)
      ERROR_STRINGS.any? { |str| value.to_s.match(str) } ||
        key.to_s.casecmp('message').zero?
    end

    # Given a key, convert to symbol, removing XML namespace, if any.
    # @param [String] key - a key, either "abc" or "abc:def"
    # @return [Symbol]
    def symbolize_key(key)
      return key unless key.respond_to?(:split)
      key.split(':').last.underscore.to_sym
    end

    # Recursively transforms a hash
    # @param [Hash] hash
    # @return [Hash]
    def symbolize_keys_deep(hash)
      return hash unless hash.is_a?(Hash)

      Hash[hash.map do |key, value|
        # if value is array, loop each element and recursively symbolize keys
        if value.is_a? Array
          value = value.map { |element| symbolize_keys_deep(element) }
          # if value is hash, recursively symbolize keys
        elsif value.is_a? Hash
          value = symbolize_keys_deep(value)
        end

        [symbolize_key(key), value]
      end]
    end

    # @param [Array] errors
    def raise_errors(errors)
      error_string = errors.join(',')
      error = Zuora::Errors::InvalidValue.new(error_string, to_h)
      fail error
    end
  end
end
