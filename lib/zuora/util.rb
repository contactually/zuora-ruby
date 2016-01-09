module Zuora
  module Util
    def self.attr_hash(object, attrs)
      Hash[
        attrs.map do |attr|
          str = attr.to_s
          key = str.camelize(:lower)
          val = object.send(attr)
          val = val.attributes if val.respond_to?(:attributes)
          [key, val]
        end
      ]
    end
  end
end