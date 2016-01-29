require 'active_support/core_ext/hash/conversions'

module Zuora
  class Response
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

    private

    # Given a key, convert to symbol, removing XML namespace, if any.
    # @param [String] key - a key, either "abc" or "abc:def"
    # @return [Symbol]
    def symbolize_key(key)
      return key unless key.respond_to?(:split)
      key.split(':').last.underscore.to_sym
    end

    # Recursively transforms a hash
    # @param [String] hash
    # @return [Hash]
    def symbolize_keys_deep(hash)
      return hash unless hash.is_a?(Hash)
      Hash[
        hash.map do |k, v|
          [symbolize_key(k), symbolize_keys_deep(v)]
        end
      ]
    end
  end
end
