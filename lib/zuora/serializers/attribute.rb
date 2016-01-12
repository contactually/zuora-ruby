module Zuora
  module Serializers
    module Attribute
      # @param [Object] model: An object responding to .attributes
      #                        for which each attr can be .send(attr)
      # @param [Hash] { [String]: lowerCamelCased key =>
      #                 [Any]: value }
      def self.serialize(model)
        attrs = model.attributes
        attr_pairs =  attrs.map { |attr| serialize_attr model, attr }
        Hash[attr_pairs]
      end

      private

      def self.serialize_attr(object, attr)
        # Camelizes the stringified attribute name

        # Note: This specific transformation (lowerCamelCase)
        # could be passed in; decoupling recursive traversal
        # from the end-node render / transformation.
        key = attr.to_s.camelize(:lower)

        # Get current attribute's property
        val = object.send(attr)

        # Recursively serialize this attribute's
        # attributes, if they are defined
        val = serialize val if val.respond_to?(:attributes)

        [key, val]
      end
    end
  end
end
