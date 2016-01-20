require_relative 'composite_types'
require 'byebug'

module SchemaModel
  def self.included(base)
    base.include InstanceMethods
    base.extend ClassMethods
  end

  module ClassMethods
    # Dynamically configures accessors, dirty tracking, validation,
    # and serialization methods given definition in opts
    # @param [Object] _name - name of schema
    # @param [Hash] opts - See below
    #
    #  class AwesomeClass
    #    schema :my_schema,
    #      id: {
    #       type: Numeric,             # value will be checked using is_a?
    #       valid: -> (v) { v > 0 },   # value will be validated by calling this
    #       schema: [ChildClass]       # single or collection recursive checks
    #       doc: 'Id, number greater than 1'  # documentation string
    #      }
    #  end
    #
    #  a = AwesomeClass.new(id: 1)
    #  a.valid? => true
    #  a.errors => {}
    #
    def schema(_name, opts = {})
      define_method(:definition) { opts }

      opts.each do |k, definition|
        # Reader
        attr_reader k

        # Writer
        define_writer! k, definition
      end
    end

    private

    # Helper for dynamically defining writer method
    # @param [Symbol] k - name of attribute
    # @param [Hash] definition - See docstring for schema above
    def define_writer!(k, definition)
      define_method("#{k}=") do |value|
        # Recursively convert hash and array of hash to schematized objects
        value = ensure_schema value, definition[:schema]

        # Initial value
        instance_variable_set "@#{k}", value

        # Dirty tracking
        self.changed_attributes ||= Set.new
        self.changed_attributes << k
      end
    end
  end

  module InstanceMethods
    attr_accessor :changed_attributes

    def initialize(attrs = {})
      attrs.each do |attr, v|
        send("#{attr}=", v)
      end
    end

    def errors
      check definition, self
    end

    def valid?
      errors.empty?
    end

    def to_json
      return nil unless changed_attributes
      Hash[
        changed_attributes.map { |attr| serialize_attr(attr) }
      ]
    end

    private

    # @param [Symbol] attr
    # @return [Array]
    def serialize_attr(attr)
      value = send(attr)
      value = if value.is_a?(Hash) || value.is_a?(SchemaModel)
                value.to_json
              elsif value.is_a?(Array)
                value.map(&:to_json)
              else
                value
              end

      [attr.to_s.camelize(:lower), value]
    end

    # Given a schema and a value which may be a single record or collection,
    # collect and return any errors.
    # @param [SchemaModel] child_schema - A schema object class
    # @param [Object] value - Array of models or single model
    # @return [Object] Array of errors hashes, or one hash.
    #                   Structure matches 'value' input
    def check_children(child_schema, value)
      return unless child_schema && value.present?

      if value.is_a? Array
        value.map(&:errors).reject(&:empty?)
      else
        value.errors
      end
    end

    # Checks that value is of correct type
    # @param [Maybe Class] type - type to check using value.is_a?(type)
    # @param [Object] value - value to check
    # @return [Maybe String] error message
    def check_type(type, value)
      return unless type && value && !value.is_a?(type)

      "should be of type #{type} but is of type #{value.class}"
    end

    # Checks that required field meets validation
    # @param [Boolean or Callable] valid - callable validation fn or boolean
    #                               function will be called with value
    # @param [Object] value - value to check
    # @return [Maybe String] error message
    def check_validation(valid, value)
      return unless valid && value

      passes_validation = valid.call(value) rescue false
      passes_validation ? nil : 'is invalid'
    end

    # Mutates errors, adding in error messages scoped to the attribute and key
    # @param [Maybe Hash] errors -
    # @param [Symbol] attr - name of attribute under check
    # @param [Symbol] key - name of validation step
    # @param [Object] val - data to append
    def append!(errors, attr, key, val)
      return unless val.present?

      errors ||= {}
      errors[attr] ||= {}
      errors[attr][key] = val
    end

    # @param [Hash] schema
    # @param [Hash|Object] data
    # @return [Hash]
    def check(schema, data)
      schema.reduce({}) do |errors, (attr, defn)|
        # Destructuring
        child_schema, type = defn.values_at :schema, :type

        # Get the value for this attribute
        value = data.send attr

        # Add error messages
        append! errors, attr, :child, check_children(child_schema, value)
        append! errors, attr, :type, check_type(type, value)
        errors
      end
    end

    # Constructs new instance(s) of provided Schema model from hash or
    # array of hash values. Allows for modeling of has_one and has_many.
    # @param [Array of Hashes or SchemaModels] value
    # @param [SchemaModel] child_schema

    def ensure_schema(value, child_schema)
      if value.present? && child_schema.present?
        value = if child_schema.is_a?(Array)
                  value.map do |item|
                    item.is_a?(SchemaModel) ? item : child_schema[0].new(item)
                  end
                else
                  value.is_a?(SchemaModel) ? value : child_schema.new(value)
                end
      end

      value
    end
  end
end
