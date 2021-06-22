require "helium/struct/undefined"
require "helium/struct/attribute"

module Helium
  module Struct
    module Attributes
      def self.included(mod)
        mod.singleton_class.include(ClassMethods)

        mod.dependency :attributes do
          mod.schema
            .map {|key, attribute| [key, attribute.build_value(self)] }
            .to_h
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
        def attributes
          schema.keys
        end

        def attribute(name, **opts, &block)
          schema[name] = Attribute.new(**opts)

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
