module Zuora
  module Calls
    class Generate < Hashie::Dash
      property :objects, required: true

      OBJECT_TYPE = :Invoice.freeze

      # Generates a function that takes a builder
      # and updates object(s) of type.
      # @return [Callable] - function of builder
      def xml_builder
        fail 'objects must respond to :each' unless objects.respond_to?(:each)

        lambda do |builder|
          builder[:ns1].update do
            Zuora::Utils::Envelope.build_objects builder, OBJECT_TYPE, objects
          end
        end
      end
    end
  end
end
