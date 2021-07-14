require "helium/dependency"
require "helium/initialization"
require "helium/struct/attribute"
require "helium/struct/value"


module Helium
  module Struct
    module Attributes
      def self.included(mod)
        mod.class_eval do
          include Initialization
          include Dependency
          extend ClassMethods

          dependency(:values) { Hash.new }
          dependency(:value_class) { self.class.value_class }

          before_initialize do
            self.class.schema.each do |name, attribute|
              value = values[name] ||= value_class.new
              attribute.process_value(value: value, form: self)
            end
          end
        end
      end

      def delete(attr_name)
        values[attr_name].clear!
      end

      def [](name)
        values[name].value
      end

      def []=(name, value)
        values[name].value = value
      end

    private

      module ClassMethods
        def attribute_class
          return @attribute_class if defined? @attribute_class

          base = superclass.respond_to?(:attribute_class) ? superclass.attribute_class : Attribute
          @attribute_class ||= Class.new(base)
        end

        def value_class
          return @value_class if defined? @value_class

          base = superclass.respond_to?(:value_class) ? superclass.value_class : Value
          @value_class ||= Class.new(base)
        end

        def attributes
          schema.keys
        end

        def attribute(name, **opts, &block)
          schema[name] = attribute_class.new(**opts)

          define_method name do
            self[name]
          end

          define_method "#{name}=" do |value|
            self[name] = value
          end

          name
        end

        def schema
          @schema ||= {}
        end
      end
    end
  end
end
