require "helium/struct/attribute"
require "helium/struct/value"

module Helium
  module Struct
    module Attributes
      def self.included(mod)
        mod.extend(ClassMethods)
      end

      def initialize(values: nil, **)
        @values = values || self.class.schema.transform_values { |key, _| self.class.value_class.new }

        self.class.schema.each do |name, attribute|
          attribute.process_value(value: @values[name], form: self)
        end

      end

      def undefined?(attr_name)
        values[attr_name].undefined?
      end

      def defined?(attr_name)
        !undefined?(attr_name)
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

      attr_reader :values

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
