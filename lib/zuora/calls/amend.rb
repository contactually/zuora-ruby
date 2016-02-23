module Zuora
  module Calls
    class Amend < Hashie::Dash
      property :amendments, required: true
      property :amend_options
      property :preview_options

      # Returns a function that given a builder, constructs an Ammendment
      # @return [Callable] function of builder
      def xml_builder
        lambda do |builder|
          builder[:api].amend do
            builder[:api].requests do
              Array.wrap(amendments).each do |amendment|
                build_object builder, :amendments, amendment, :obj
              end
              build_object builder, :amend_options, amend_options, :api
              build_object builder, :preview_options, preview_options, :api
            end
          end
        end
      end

      private

      # Builds one node. Behavior differs based on whether value is a hash
      # If value is a hash, a parent node is rendered and the call is applied
      # to its children.
      # If it is a child node, a child node is rendered.
      # @param [Nokogiri::XML::Builder] builder
      # @param [Symbol] child_ns - child namespace
      # @param [Symbol] field - snake case name of a Zuora object or field
      # @param [Enumerable or Object] - parent or child node
      # @return nil
      def build_node(builder, child_ns, field, value)
        field = Zuora::Utils::Envelope.to_zuora_key field
        if value.respond_to?(:each)
          # Parent
          builder[:api].send(field) { build_nodes builder, value, child_ns }
        else
          # Child
          builder[child_ns].send(field, value)
        end
      end

      # Takes a hash and builds SOAP XML nodes. See build_node for behavior.
      # @param [Nokogiri::XML::Builder] builder
      # @param [Enumerable] root
      # @param [Symbol] child_ns - child node namespace
      # @return nil
      def build_nodes(builder, root, child_ns)
        root.each(&->(k, v) { build_node builder, child_ns, k, v })
      end

      # Helper to recursively build XML from nested objects.
      # @param [Nokogiri::XML::Builder] builder
      # @param [Symbol] property_name - name of a property on this object
      # @param [Symbol] child_ns - namespace of child node fields
      # @return nil
      def build_object(builder, property_name, object, child_ns)
        fail 'Objects must respond to each' unless object.respond_to?(:each)
        object_name = Zuora::Utils::Envelope.to_zuora_key property_name
        builder[:api].send(object_name) do
          build_nodes builder, object, child_ns
        end
      end
    end
  end
end
