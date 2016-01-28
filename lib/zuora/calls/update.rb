module Zuora
  module Calls
    class Update < Hashie::Dash
      # @params [Symbol] type e.g. :BillRun, :Refund
      # @params [Array] objects - collection of objects of type `type`
      property :type, required: true
      property :objects, required: true

      # Generates a function that takes a builder
      # and updates object(s) of type.
      # @return [Callable] - function of builder
      def xml_builder
        fail 'objects must respond to :each' unless objects.respond_to?(:each)

        lambda do |builder|
          builder[:api].update do
            Zuora::Utils::Envelope.build_objects builder, type, objects
          end
        end
      end
    end
  end
end
