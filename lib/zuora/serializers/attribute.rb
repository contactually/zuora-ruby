module Zuora
  module Serializers
    module Attribute
      def self.serialize(model)
        attrs = model.attributes
        attr_pairs =  attrs.map { |attr| self.serialize_attr model, attr }
        Hash[attr_pairs]
      end

      private

      def self.serialize_attr(object, attr)
        # Camelize the stringified attribute name

        # Todo: this specific transformation could be passed in as
        # a lambda. This would allow any arbitrary function
        # of the attr/value to be passed in. It would also
        # effectively decouple the movement along the structure
        # (recursion, method check) from the end key/value
        # transformation for nodes.
        key = attr.to_s.camelize(:lower)

        # Get current attribute's property
        val = object.send(attr)

        # Recursively serialize this attribute's
        # attributes, if they are defined
        if val.respond_to?(:attributes)
          val = self.serialize val
        end

        [key, val]
      end
    end
  end
end