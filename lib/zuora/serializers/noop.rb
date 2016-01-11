module Zuora
  module Serializers
    module Noop
      def self.serialize(model)
        attrs = model.attributes
        attr_pairs =  attrs.map { |attr| self.serialize_attr model, attr }
        Hash[attr_pairs]
      end

      private

      def self.serialize_attr(object, attr)
        val = object.send(attr)
        [attr, val]
      end
    end
  end
end
