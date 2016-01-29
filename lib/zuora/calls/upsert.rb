module Zuora
  module Calls
    class Upsert < Hashie::Dash
      # Base class for Create and Update

      # @params [Symbol] type e.g. :BillRun, :Refund
      # @params [Array] objects - collection of objects of type `type`
      property :type, required: true
      property :objects, required: true

      def call_name
        fail 'This class is abstract. Subclassers must def :call_name'
      end

      # Generates a function that takes a builder
      # adds call of call_name and z-object(s) ogit rf type
      # @return [Callable] - function of builder
      def xml_builder
        fail 'objects must respond to :each' unless objects.respond_to?(:each)

        lambda do |builder|
          builder[:api].send(call_name) do
            Zuora::Utils::Envelope.build_objects builder, type, objects
          end
        end
      end
    end
  end
end
