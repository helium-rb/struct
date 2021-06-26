require "helium/struct/undefined"
require "helium/struct/attribute"

module Helium
  module Struct
    module Attributes
      def self.included(mod)
        mod.singleton_class.include(ClassMethods)

        mod.dependency :attributes do
          mod.schema.transform_values { |key, _| self.class.value_class.new }
        end
      end

      def undefined?(attr_name)
        attributes[attr_name].undefined?
      end

      def defined?(attr_name)
        !undefined?(attr_name)
      end

      def delete(attr_name)
        attributes[attr_name].clear!
      end

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
            attributes[name].value
          end

          define_method "#{name}=" do |value|
            attributes[name].value = value
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
