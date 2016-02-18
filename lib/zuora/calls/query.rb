module Zuora
  module Calls
    class Query < Hashie::Dash
      # This constructor has two arities.
      # Arity 1: provide a raw ZOQL query string
      # .new 'SELECT Id FROM Account WHERE Id = '1')

      # Arity 2: provide simple query components
      # .new [:id], :account, { :id => 1 }) will be transformed into query above

      # @param [String|Array] select - query statement or field name sym array
      # @param [Symbol|Nil] from -  table name symbol
      # @param [Symbol|Nil] where - hash of equalities for where clauses
      #    Operations: only = is supported
      #    Custom field names are supported: some_field__c => SomeField__c
      # @return [Zuora::Calls:Query]
      def initialize(select, from = nil, where = nil)
        @query_string = if select.is_a? Array
                          query_to_string(select, from, where)
                        else
                          select
                        end
      end

      # @return [Callable]
      def xml_builder
        lambda do |builder|
          builder[:api].query { builder[:api].queryString(@query_string) }
        end
      end

      private

      # @param [Array] fields
      # @param [Symbol] table
      # @param [Hash] conditions
      def query_to_string(fields, table, conditions)
        fail 'Fields must be an Array' unless fields.is_a?(Array)
        fail 'Table must respond to :to_sym' unless table.respond_to?(:to_sym)
        fail 'Conditions must be Array' if fields && !fields.is_a?(Array)

        key_fn = ->(key) { Zuora::Utils::Envelope.to_zuora_key(key) }

        select = fields.map { |field| key_fn[field] }.join(', ').to_s
        from = table.to_s
        where = 'WHERE ' + conditions.map do |key, value|
          "#{key_fn[key]} = '#{value}'"
        end.join(' AND ') if conditions

        "SELECT #{select} FROM #{from} #{where}".strip.squeeze(' ')
      end
    end
  end
end
