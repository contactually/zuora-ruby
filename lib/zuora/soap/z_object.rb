# frozen_string_literal: true

module Zuora
  module Soap
    class ZObject
      extend Forwardable

      attr_reader :type, :fields

      # @params [Symbol] - name of ZObject
      # @params [Hash] - a hash of fields
      def initialize(type, fields)
        @type = type
        @fields = fields
      end

      def_delegators :@fields, :each, :map, :reduce, :inspect, :to_i
    end
  end
end
