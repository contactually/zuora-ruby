module Zuora
  module Models
    module Utils
      # Calls `validate_each` on for each provided attribute.
      # Attaches error generated via message fragment.
      # e.g. 'invalid widget'
      #
      # @param [Object] sender;
      # @param [String] message
      # @param [Array<Symbol>] fields
      # @return [Nil]
      def self.validate_children(sender, message, *fields)
        sender.validates_each fields do |record, attr, value|
          if !value.respond_to?(:valid?) || !value.respond_to?(:errors)
            record.errors.add attr, "invalid #{message}"
          elsif value.invalid?
            record.errors.add attr, value.errors.join(',')
          end
        end
      end
    end
  end
end
