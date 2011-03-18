require 'hashie'
require 'property_types'
require 'validations'

module Modelish
  class Base < Hashie::Trash
    include PropertyTypes
    include Validations

    # Creates a new attribute.
    #
    # @param [Symbol] name the name of the property
    # @param [Hash] options configuration for the property
    # @option opts [Object] :default the default value for this property
    #                                when the value has not been explicitly
    #                                set (defaults to nil)
    # @option opts [#to_s] :from the original key name for this attribute
    #                            (created as write-only)
    # @option opts [Class,Proc] :type the type of the property value. For
    #                                 a list of accepted types, see
    #                                 {Modelish::PropertyTypes}
    # @options opts [true,false] :required enables validation for the property
    #                                      value's presence; nil or blank values
    #                                      will cause validation methods to fail
    # @options opts [Integer] :max_length the maximum allowable length for a valid
    #                                     property value
    # @options opts [Proc] :validator A block that accepts a value and validates it;
    #                                 should return nil if validation passes, or an error
    #                                 message or error object if validation fails.
    #                                 See {Modelish::Validations}
    def self.property(name, options={})
      super

      add_property_type(name, options[:type]) if options[:type]
      add_validator(name) { |val| validate_required(name => val).first } if options[:required]
      add_validator(name) { |val| validate_length(name, val, options[:max_length]) } if options[:max_length]
      add_validator(name, &options[:validator]) if options[:validator]
    end
  end
end
