# Thanks to @jcarbo, @jwg2s, @jbender

# Rationale:

# Create classes of objects with a self-enforcing schemas, and the ability to
# track which fields have changed.

# Useful in modeling, validating, and serializing remote API endpoints,
# especially for PATCH updates where sending ambiguous nil values could
# override invisible defaults.

# Features:

#  - attr_accessor like getter and setters, plus...
#  - constructor checks required fields with support for multi-field
#       validation predicates
#  - per attribute coercion
#  -               type check
#  -               validation
#  - dirty attribute tracking: what changed?
#  (checks  are all optional, and are applied in the above order)

require 'set'
require_relative 'validation_predicates'

## Composite Types
module Boolean; end
class TrueClass; include Boolean; end
class FalseClass; include Boolean; end
# All roads lead to TrueClass
# true.is_a? Boolean => true (.is_a? Boolean => true ... )
# false.is_a? Boolean => true (.is_a? Boolean => true ... )

module DirtyValidAttr
  def self.included(base)
    base.include InstanceMethods
    base.extend ClassMethods
    base.extend ValidationPredicates
  end

  module InstanceMethods
    attr_accessor :changed_attributes
    attr_accessor :attributes

    def fail_validation!(attr, value)
      message = "Invalid value for: attr: #{attr} - value: #{value}}"
      fail message
    end

    def fail_type!(attr, value, type)
      fail %(Invalid type for: attr: #{attr}
                   - value: #{value}
                   - is: #{value.class}
                   - should be: #{type})
    end

    def coerce_value(coerce, value)
      return coerce.call(value)
    rescue
      throw "Unable to coerce #{value}"
    end
  end

  module ClassMethods
    attr_accessor :attr_definitions

    # @param [symbol] attr - attribute name
    # @param [Hash] options - {[Class] type - checked using .is_a?, optional
    #                          [Proc] valid? - predicate fn, optional
    #                          [Proc] coerce - coercion fn, optional
    #                          [Boolean] required? - default: nil (falsy)
    def dirty_valid_attr(attr, options = {})
      upsert_attr_definition! attr, options

      # Setter
      define_setter attr, options

      # Getter
      attr_reader attr
    end

    private

    # Defines setter method for instance (plus validation)
    # @param [Object] attr
    # @param [Object] options
    def define_setter(attr, options = {})
      define_method("#{attr}=") do |value|
        self.changed_attributes ||= Set.new

        type, validation, coerce = options.values_at(:type, :valid?, :coerce)
        value = coerce_value(coerce, value) if coerce
        fail_validation!(attr, value) if validation && !validation.call(value)
        fail_type!(attr, value, type) unless type && value.is_a?(type)

        changed_attributes << attr
        instance_variable_set "@#{attr}", value
      end
    end

    # Upsert to class-level hash of {attr => options}
    # @param [Sym] attr - attribtue name
    # @param [Hash] options - see structure in dirty_valid_attr
    # @sfx Updates class-level method
    def upsert_attr_definition!(attr, options)
      self.attr_definitions ||= {}
      self.attr_definitions[attr] = options
    end
  end

  # @param [Hash] attrs - initial attribute keys and values
  # @return [Nil]
  def initialize_attributes!(attrs = {})
    required = required_attrs(attrs)
    missing = required.keys - attrs.keys
    fail "Missing required attrs: #{missing} " unless missing.empty?
    attrs.each do |attr, v|
      send("#{attr}=", v)
    end
  end

  private

  # @param [Hash] attrs - [Symbol] attr
  #                       [String] value
  # @return [Hash] -      [String] attr
  #                       [Hash] options (:required?, :valid?, :coerce)
  def required_attrs(attrs = {})
    # An attribute is determined to be 'missing' using the :required? key.
    # if provided present in the attribute's definition.
    #
    # If :required? is callable, call it on attrs.
    #  This allows for expression logic like:
    #  require attr A if attr B == 3
    # Else
    #  Use the boolean value true, or nil/false
    #  Defaults to :required? nil(false)
    #
    self.class.attr_definitions.select do |_attr, definition|
      required = definition[:required?]
      required.respond_to?(:call) ? required.call(attrs) : required
    end
  end
end

# class Account
#   include DirtyValidAttr
#
#   dirty_valid_attr :fuz,
#                    type: String,
#                    valid: ->(attr) { attr == 'fuzz' },
#                    coerce => ->(attr) { attr.to_str }
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
#     initialize_attributes!(attrs)
#   end
# end

# Usage:

# Create a valid record
# > a = Account.new(:fuz => 'fuzz', :bizz => "4")
# <Account:0x007f8f0c9052c0 @changed_attributes=
#     #<Set: {:fuz, :bizz}>, @fuz="fuzz", @bizz=4>

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
