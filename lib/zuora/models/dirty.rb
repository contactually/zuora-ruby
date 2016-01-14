# Thanks to @jcarbo, @jwg2s, @jbender

# Rationale:

# Create classes of objects with a self-enforcing schemas,
# and the ability to track which fields have changed. Highly useful
# in modeling, validating, and serializing remote API endpoints,
# especially for PATCH updates.

# Features:

#  - attr_accessor like getter and setters, plus...
#  - dirty attribute tracking: what changed?
#  - per attribute coercion
#  - per attribute type check
#  - per attribute validation
#      (checks  are all optional, and are applied in the above order)

require 'set'

## Composite Types
module Boolean; end
class TrueClass; include Boolean; end
class FalseClass; include Boolean; end

# true.is_a? Boolean => true

module DirtyValidAttr
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      attr_accessor :changed_attributes
      attr_accessor :attributes

      def valid?
        true
      end

      def validate!(attr, value, validation)
        unless validation.call(value)
          raise("Invalid value for: attr: #{attr} - value: #{value}}")
        end
      end

      def validate_type!(attr, value, type)
        unless value.is_a?(type)
          message = %Q(Invalid type for: attr: #{attr}
                     - value: #{value}
                     - is: #{value.class}
                     - should be: #{type})
          raise(message)
        end
      end

      def coerce_value(coerce, value)
        return coerce.call(value)
      rescue
        raise "Unable to coerce #{value}"
      end
    end
  end

  module ClassMethods
    #
    # @param [symbol] attr - attribtue name
    # @param [Hash] options - {[Class] type - checked using .is_a?, optional
    #                          [Proc] valid? - predicate fn, optional
    #                          [Proc] coerce - coercion fn, optional
    def dirty_valid_attr(attr, options = {})
      type, validation, coerce = options.values_at(:type, :valid?, :coerce)

      define_method("#{attr}=") do |value|
        self.changed_attributes ||= Set.new

        value = coerce_value(coerce, value) if coerce
        validate!(attr, value, validation) if validation
        validate_type!(attr, value, type) if type

        changed_attributes << attr
        instance_variable_set "@#{attr}", value
      end

      attr_reader attr
    end
  end

  # @param [Hash] attrs - initial attribute keys and values
  # @return [Nil]
  def set_attributes!(attrs)
    attrs.each do |attr, v|
      send("#{attr}=", v)
    end
  end
end

# class Account
#   include DirtyValidAttr
#
#   dirty_valid_attr :fuz,
#                    type: String,
#                    valid: ->(attr) { attr == 'fuzz' },
#                    :coerce => ->(attr) { attr.to_str }
#
#   dirty_valid_attr :bizz,
#                    type: Fixnum,
#                    valid: ->(attr) { attr > 3 },
#                    :coerce => ->(attr){ attr.to_i }
#
#   dirty_valid_attr :gaz,
#                    type: Fixnum
#
#   def initialize(attrs)
#     set_attributes!(attrs)
#   end
# end

# Usage:

# Create a valid record
# > a = Account.new(:fuz => 'fuzz', :bizz => "4")
# <Account:0x007f8f0c9052c0 @changed_attributes=#<Set: {:fuz, :bizz}>, @fuz="fuzz", @bizz=4>

# Access changed attributes
# > a.changed_attributes
# #<Set: {:fuz, :bizz}>

# Basic coercion, validation, type checking:

# Raises on invalid value:
# > a = Account.new(:fuz => 'fuzz', :bizz => "2")
# RuntimeError: Invalid value for: attr: bizz - value: 2}

# Raises if unable to coerce
# > a = Account.new(:fuz => 'fuzz', :bizz => Set.new)
# RuntimeError: Unable to coerce #<Set:0x007f8f0b8588f0>

# Raises if invalid type
# RuntimeError: Invalid type for: attr: gaz
# - value: abc
# - is: String
# - should be: Fixnum