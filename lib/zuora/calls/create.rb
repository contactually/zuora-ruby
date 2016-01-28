module Zuora
  module Calls
    class Create < Hashie::Dash
      # @params [String] token
      # @params [Symbol] type e.g. :BillRun, :Refund
      # @params [Array] data - hash of whitelisted zuora object field names
      property :object_type, required: true
      property :data, required: true

      # Generates a function that takes a builder
      # and adds object of `type`, having `fields`, with `data`
      # @return [Callable] - function of builder
      def xml_builder
        lambda do |builder|
          builder[:ns1].create do
            builder[:ns1].zObjects('xsi:type' => "ns2:#{object_type}") do
              Zuora::Utils::Envelope.build_fields(:ns1, data)
            end
          end
        end
      end
    end
  end
end
